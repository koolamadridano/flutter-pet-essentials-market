const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const enumAccountType = ["customer", "merchant"];
      
const ProfileSchema = new Schema({
  accountId: {
    type: String,
    required: [true, "accountId is required"],
  },
  accountType: {
    type: String,
    enum: enumAccountType,
    required: [true, "accountType is required"],
  },
  name: {
    first: {
      type: String,
    },
    last: {
      type: String,
    },
  },
  address: {
    name: {
      type: String,
      required: [true, "name is required"],
    },
    coordinates: {
      latitude: {
        type: String,
        required: [true, "latitude is required"],
      },
      longitude: {
        type: String,
        required: [true, "longitude is required"],
      },
    },
  },
  contact: {
    email: {
      type: String,
      // required: [true, "email is required"],
    },
    number: {
      type: String,
      //required: [true, "contactNo is required"],
    },
  },
  img: { type: String },
  date: {
    createdAt: {
      type: Date,
      default: Date.now,
    },
    updatedAt: {
      type: Date,
    }
  },
  visibility: { 
    type: Boolean,        
    required: [true, "visibility is required"],
  },
  verified: {
    type: Boolean,
    required: [true, "verified status is required"],
  },
  /*  
    * MERCHANT PROPERTIES
    * ALL MUST BE OPTIONAL
    * USE ONLY IF ACCOUNT TYPE IS MERCHANT
  */
  merchantName: { type: String },
  merchantCanDeliver: { type: Boolean },
  serviceHrs: { type: String },
});

module.exports = Profile = mongoose.model("profiles", ProfileSchema);
