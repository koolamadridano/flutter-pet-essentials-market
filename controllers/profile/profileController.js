const Profile = require("../../models/profile");
const cloudinary = require("../../services/img-upload/cloundinary");

const createProfile = async (req, res) => {
    try {
        const accountId = req.body.accountId;
        const doesExist = await Profile.findOne({ accountId });
        if(doesExist) 
            return res.status(400).json({message: "accountId already exist"})

        return new Profile(req.body)
            .save()
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err.errors));
    } catch (error) {
        console.error(error);
    }
};

const getAllProfiles = async (req, res) => {
    try {
        const { accountType, latitude, longitude }  =  req.query;

        if(accountType === undefined) {
            return Profile.find()
                .sort({ createdAt: -1 }) // filter by date
                .select({ _id: 0, __v: 0 }) // Do not return _id and __v
                .then((value) => res.status(200).json(value))
                .catch((err) => res.status(400).json(err));
        }

        return Profile.find({ accountType })
            .sort({ createdAt: -1 }) // filter by date
            .select({ _id: 0, __v: 0 }) // Do not return _id and __v
            .then((value) => {
                function distance(lat1, lon1, lat2, lon2, unit)  {
                    var radlat1 = Math.PI * lat1/180
                    var radlat2 = Math.PI * lat2/180
                    var theta = lon1-lon2
                    var radtheta = Math.PI * theta/180
                    var dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta);
                    dist = Math.acos(dist)
                    dist = dist * 180/Math.PI
                    dist = dist * 60 * 1.1515
                    if (unit=="K") { dist = dist * 1.609344 }
                    if (unit=="N") { dist = dist * 0.8684 }
                    return dist
                }
                if(latitude != undefined && longitude != undefined) {
                    const newData = value.map((element, index)  => {
                        let start = element.address.coordinates.latitude;
                        let end = element.address.coordinates.longitude;
                        let data = {
                            ...element._doc,
                            distanceBetween: distance(start, end, latitude, longitude, "K").toFixed(1)
                        }
                        return data;
                    });
                
                    newData.sort((a, b) => parseFloat(a.distanceBetween) - parseFloat(b.distanceBetween))
                    return res.status(200).json(newData); 
                }
                return res.status(200).json(value);

            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
}

const getProfile = async (req, res) => {
    try {
        const accountId = req.params.id;
        Profile.findOne({ accountId })
            .select({ _id: 0, __v: 0 })
            .then((value) => {
                if (!value) 
                    return res.status(400).json({ message: "accountId not found" });
                return res.status(200).json(value);
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
}

const updateProfile = async (req, res) => {
    try {
        const { accountId, firstName, lastName } = req.body;
        Profile.findOneAndUpdate(
            { accountId },
            {  
                $set:  {
                    "name.first": firstName,
                    "name.last": lastName,
                    "date.updatedAt": Date.now()
                }
            }, 
            { new: true })
            .then((value) => {
                if (!value) 
                    return res.status(400).json({ message: "accountId not found" });
                return res.status(200).json(value);
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
}

const updateProfileVisibility = async (req, res) => {
    try {
        const { accountId, visibility } = req.query;
        Profile.findOneAndUpdate(
            { accountId },
            { visibility }, 
            { new: true })
            .then((value) => {
                if (!value) 
                    return res.status(400).json({ message: "accountId not found" });
                return res.status(200).json(value);
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
}

const updateProfileImg = async (req, res) => {
    try {
          const accountId = req.body.accountId;
          const filePath = req.file.path;
          const options = { 
              folder: process.env.CLOUDINARY_FOLDER + "/img", 
              unique_filename: true 
          };
          const uploadedImg = await cloudinary.uploader.upload(filePath, options);
  
          Profile.findOneAndUpdate(
              { accountId }, 
              {  
                  $set:  {
                      "img": uploadedImg.url, 
                      "date.updatedAt": Date.now()
                  }
              }, 
              { runValidators: true, new: true })
              .then((value) => {
                  if (!value) 
                      return res.status(400).json({ message: "_id not found" });
                  return res.status(200).json(value);
              })
              .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.log(error);
    }
  
}

const updateProfileAddress = async (req, res) => {
    try {
      const { accountId, name, lat, long } = req.query;

      Profile.findOneAndUpdate(
        { accountId },
        {
          $set: {
            "address.name": name,
            "address.coordinates.latitude": lat,
            "address.coordinates.longitude": long,
            "date.updatedAt": Date.now(),
          },
        },
        { new: true })
        .then((value) => {
          if (!value) {
            return res.status(400).json({ message: "accountId not found" });
          }
          res.status(200).json(value);
        })
        .catch((err) => res.status(400).json(err));
    } catch (e) {
      return res.status(400).json({ message: "Something went wrong" });
    }
}
      
const updateProfileContact = async (req, res) => {
    try {
      const { accountId, email, number } = req.query;

      Profile.findOneAndUpdate(
        { accountId },
        {
          $set: {
            "contact.email": email,
            "contact.number": number,
            "date.updatedAt": Date.now(),
          },
        },
        { new: true })
        .then((value) => {
            if (!value)
                return res.status(400).json({ message: "accountId not found" });
            return res.status(200).json(value);
        })
        .catch((err) => res.status(400).json(err));
    } catch (e) {
      return res.status(400).json({ message: "Something went wrong" });
    }
}

const deleteProfile = async (req, res) => {
    try {
        const accountId = req.params.id;
        Profile.findOneAndRemove({ accountId })
            .then((value) => {
                if (!value) 
                    return res.status(400).json({ message: "accountId not found" });
                return res.status(200).json({ message: "deleted" });
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.log(error);
    }
}


module.exports = {
    createProfile,
    getAllProfiles,
    getProfile,
    updateProfile,
    deleteProfile,
    updateProfileImg,
    updateProfileContact,
    updateProfileAddress,
    updateProfileVisibility
}
