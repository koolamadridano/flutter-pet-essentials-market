import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controllers/profileController.dart';
import 'package:app/controllers/userController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MerchantMain extends StatefulWidget {
  const MerchantMain({Key? key}) : super(key: key);

  @override
  State<MerchantMain> createState() => _MerchantMainState();
}

class _MerchantMainState extends State<MerchantMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _profile = Get.put(ProfileController());
  final _user = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      title: Text(
        _profile.data["merchantName"],
        style: GoogleFonts.chivo(
          fontSize: 16.0,
          color: kDark,
        ),
      ),
      leading: const SizedBox(),
      leadingWidth: 0.0,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 15.0),
          child: IconButton(
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            splashRadius: 20.0,
            icon: const Icon(
              Ionicons.menu,
              color: kDark,
            ),
          ),
        )
      ],
      backgroundColor: kWhite,
      elevation: 0,
      shape: Border(
        bottom: BorderSide(
          color: kDark.withOpacity(0.2),
          width: 0.5,
        ),
      ),
    );
    final _drawer = Drawer(
      backgroundColor: kLight,
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: kPrimary,
              image: DecorationImage(
                image: NetworkImage(_profile.data["img"]),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  kPrimary.withOpacity(0.7),
                  BlendMode.dstOut,
                ),
              ),
            ),
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              currentAccountPictureSize: const Size.square(70.0),
              margin: const EdgeInsets.all(0),
              accountName: Text(
                _profile.data["merchantName"],
                style: GoogleFonts.chivo(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              accountEmail: Text(
                _profile.data["contact"]["email"],
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          // ListTile(
          //   onTap: () => _user.logout(),
          //   leading: const Icon(
          //     AntDesign.user,
          //     size: 20.0,
          //     color: kDark,
          //   ),
          //   title: Text(
          //     "Profile",
          //     style: GoogleFonts.chivo(
          //       fontSize: 14.0,
          //       color: kDark,
          //     ),
          //   ),
          // ),
          // const Divider(),
          ListTile(
            onTap: () => _user.logout(),
            leading: const Icon(
              Ionicons.receipt_outline,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "My Orders",
              style: GoogleFonts.chivo(
                fontSize: 14.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.toNamed("/merchant-additem"),
            leading: const Icon(
              AntDesign.plus,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "Add Item",
              style: GoogleFonts.chivo(
                fontSize: 14.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.toNamed("/merchant-posteditems"),
            leading: Icon(
              Entypo.list,
              size: 24.0,
              color: kDark.withOpacity(0.8),
            ),
            title: Text(
              "My Posted Items",
              style: GoogleFonts.chivo(
                fontSize: 14.0,
                color: kDark,
              ),
            ),
          ),
          const Spacer(flex: 5),
          ListTile(
            onTap: () => _user.logout(),
            leading: Icon(
              MaterialCommunityIcons.logout_variant,
              size: 24.0,
              color: kDark.withOpacity(0.8),
            ),
            title: Text(
              "Log out",
              style: GoogleFonts.chivo(
                fontSize: 14.0,
                color: kDark,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );

    final _containerAddItem = Expanded(
      child: GestureDetector(
        onTap: () => Get.toNamed("/merchant-additem"),
        child: Container(
          decoration: const BoxDecoration(
            color: kPrimary,
            borderRadius: kDefaultRadius,
          ),
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                AntDesign.plus,
                color: kLight,
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ADD ITEM",
                    style: GoogleFonts.chivo(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: kLight,
                    ),
                  ),
                  Text(
                    "Upload Products\nto my store",
                    style: GoogleFonts.chivo(
                      fontSize: 12.0,
                      color: kLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    final _containerMyOrders = Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: kDefaultRadius,
          ),
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Ionicons.receipt_outline,
                color: kLight,
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MY ORDERS",
                    style: GoogleFonts.chivo(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: kLight,
                    ),
                  ),
                  Text(
                    "Manage and View \nCustomer Orders",
                    style: GoogleFonts.chivo(
                      fontSize: 12.0,
                      color: kLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    final _containerPosteItems = GestureDetector(
      onTap: () => Get.toNamed("/merchant-posteditems"),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: kDefaultRadius,
        ),
        padding: const EdgeInsets.all(27.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FontAwesome.th_list,
              color: kLight,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MY POSTED ITEMS",
                  style: GoogleFonts.chivo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: kLight,
                  ),
                ),
                Text(
                  "View and Manage uploaded products",
                  style: GoogleFonts.chivo(
                    fontSize: 12.0,
                    color: kLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: kWhite,
        appBar: _appBar,
        drawer: _drawer,
        body: Container(
          margin: kDefaultBodyMargin,
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Row(
                children: [
                  _containerAddItem,
                  const SizedBox(width: 5),
                  _containerMyOrders,
                ],
              ),
              const SizedBox(height: 5.0),
              _containerPosteItems
            ],
          ),
        ),
      ),
    );
  }
}
