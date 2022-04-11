const Order = require("../../models/order");
const { v4: uuidv4 } = require('uuid');

const createOrder = async (req, res) => {
    try {
        req.body.refNumber = uuidv4().toUpperCase();
        return new Order(req.body)
            .save()
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err.errors));
    } catch (error) {
        console.error(error);
    }
}

const getOrders = async (req, res) => {
    try {
            const { accountId, accountType, status } =  req.query;
            if(accountType === "customer") {
                return Order.find({"header.customer.accountId": accountId, status})
                    .sort({ "date.createdAt": "desc" }) // filter by date
                    .select({ __v: 0 }) // Do not return _id and __v
                    .then((value) => res.status(200).json(value))
                    .catch((err) => res.status(400).json(err));
            }
            if(accountType === "merchant") {
                return Order.find({"header.station.accountId": accountId, status})
                    .sort({ "date.createdAt": "asc" }) // filter by date
                    .select({ __v: 0 }) // Do not return _id and __v
                    .then((value) => res.status(200).json(value))
                    .catch((err) => res.status(400).json(err));
            }
    } catch (error) {
        console.error(error);
    }
}

const updateOrderStatus = async (req, res) => {
    const { _id, status} =  req.query;
    try {
        Order.findByIdAndUpdate(_id, 
            {  
                $set:  {
                    status, 
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
        console.error(error);
    }
}

const deleteOrder = async (req, res) => {
    try {
        const id = req.params.id;
        Order.findByIdAndDelete(id)
            .then((value) => {
                if (!value) 
                    return res.status(400).json({ message: "_id not found" });
                return res.status(200).json({ message: "_id deleted"});
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.log(error);
    }
}
module.exports = {
    createOrder,
    getOrders,
    updateOrderStatus,
    deleteOrder
}
