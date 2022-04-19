import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/const/strings.dart';
import 'package:app/controllers/cartController.dart';
import 'package:app/controllers/listingController.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/helpers/generate_minmax.dart';
import 'package:app/widget/bottomsheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerViewProduct extends StatefulWidget {
  const CustomerViewProduct({Key? key}) : super(key: key);

  @override
  State<CustomerViewProduct> createState() => _CustomerViewProductState();
}

class _CustomerViewProductState extends State<CustomerViewProduct> {
  final GlobalKey<ExpansionTileCardState> _tileKey = GlobalKey();

  final _listing = Get.put(ListingController());
  final _profile = Get.put(ProfileController());
  final _cart = Get.put(CartController());

  late Future _getMerchant;
  late Future _getListings;

  List<Widget> images(images) {
    List<Widget> _images = [];
    for (var image in images) {
      final widget = Image.network(
        image["url"],
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
      );
      _images.add(widget);
    }
    return _images;
  }

  Future<void> onAddToCart(data) async {
    if (_cart.items.isNotEmpty) {
      final _selectedListing = _listing.selectedListing["accountId"];
      final _cartMerchantId = _cart.items[0]["accountId"];
      if (_selectedListing != _cartMerchantId) {
        bottomSheet(
          action: () {
            _cart.items.clear();
            _cart.add({"qty": 1, ...data});
            Future.delayed(const Duration(milliseconds: 200), () {
              bottomSheet(
                message: "Added to cart successfully!",
                type: BottomSheetType.toast,
              );
            });
          },
          message: Strings.removePreviousItemMessage,
          type: BottomSheetType.removePreviousItem,
        );
        return;
      }
    }
    _cart.add({"qty": 1, ...data});
    Future.delayed(const Duration(milliseconds: 200), () {
      bottomSheet(
        message: "Added to cart successfully!",
        type: BottomSheetType.toast,
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMerchant = _profile.getMerchantProfile(
      _listing.selectedListing["accountId"],
    );
    _getListings = _listing.getListings(
      merchantId: _listing.selectedListing["accountId"],
    );
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _tileKey.currentState!.expand();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLight,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            stretch: true,
            backgroundColor: kLight,
            // leadingWidth: 0,
            // leading: const SizedBox(),
            //elevation: 0,
            leading: IconButton(
              onPressed: () => Get.toNamed("/customer-main"),
              splashRadius: 20.0,
              icon: const Icon(
                Ionicons.arrow_back_circle,
                color: Colors.deepOrange,
                size: 32.0,
              ),
            ),
            pinned: true,
            // title: Text(
            //   "This is a title",
            //   style: GoogleFonts.roboto(
            //     color: kDark,
            //     fontSize: 16.0,
            //   ),
            // ),
            flexibleSpace: FlexibleSpaceBar(
              background: CarouselSlider(
                items: images(_listing.selectedListing["images"]),
                options: CarouselOptions(
                  height: 500,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 7),
                  autoPlayAnimationDuration: const Duration(
                    milliseconds: 800,
                  ),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {},
                  scrollDirection: Axis.horizontal,
                ),
              ),
              stretchModes: const [
                StretchMode.blurBackground,
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
            ),
            actions: [],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  ExpansionTileCard(
                    key: _tileKey,
                    duration: const Duration(milliseconds: 400),
                    turnsCurve: Curves.bounceInOut,
                    colorCurve: Curves.bounceInOut,
                    baseColor: kLight,
                    expandedColor: kLight,
                    elevation: 0,
                    leading: IconButton(
                      onPressed: () => onAddToCart(_listing.selectedListing),
                      splashRadius: 20.0,
                      icon: const Icon(
                        Ionicons.cart,
                        color: kDark,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _listing.selectedListing["title"],
                          style: GoogleFonts.chivo(
                            fontSize: 16.0,
                            color: kDark.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          "PHP ${_listing.selectedListing["price"]}",
                          style: GoogleFonts.rajdhani(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: kDanger,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _listing.selectedListing["description"],
                              style: GoogleFonts.roboto(
                                color: kDark,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Divider()),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: _getMerchant,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.none) {
                  return const SizedBox();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }
                if (snapshot.data == null) {
                  return const SizedBox();
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.length == 0) {
                    return const SizedBox();
                  }
                }

                return Container(
                  padding: const EdgeInsets.all(20.0),
                  color: kLight,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          print("VIEW STORE");
                        },
                        icon: const Icon(
                          MaterialCommunityIcons.store,
                          color: kDark,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data["merchantName"],
                            style: GoogleFonts.roboto(
                              color: kDark,
                              fontSize: 15.0,
                            ),
                          ),
                          Text(
                            snapshot.data["address"]["name"],
                            style: GoogleFonts.roboto(
                              color: kDark,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SliverFillRemaining(
            child: FutureBuilder(
              future: _getListings,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.none) {
                  return const SizedBox();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }
                if (snapshot.data == null) {
                  return const SizedBox();
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.length == 0) {
                    return const SizedBox();
                  }
                }
                return Container(
                  margin: kDefaultBodyMargin,
                  child: RefreshIndicator(
                    onRefresh: () async {},
                    child: GridView.builder(
                      itemCount: snapshot.data.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: 0.69,
                      ),
                      itemBuilder: (context, index) {
                        final _rnd = randomNumber(1, 5);
                        final _title = snapshot.data[index]["title"];
                        final _img =
                            snapshot.data[index]["images"][_rnd]["url"];
                        final _price = snapshot.data[index]["price"];

                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            color: kWhite,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 200.0,
                                  child: CachedNetworkImage(
                                    imageUrl: _img,
                                    fit: BoxFit.contain,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _title,
                                        style: GoogleFonts.roboto(
                                          color: kDark,
                                          fontSize: 13.0,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "PHP $_price",
                                        style: GoogleFonts.rajdhani(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: kDanger,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
