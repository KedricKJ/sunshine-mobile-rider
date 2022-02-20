const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Message } = require("firebase-functions/lib/providers/pubsub");

admin.initializeApp(functions.config().functions);

var newData;

exports.orderNotificationTrigger = functions.firestore.document('OrderNotifications/{id}')
.onCreate(async (snapshot,context)=>{

    if(snapshot.empty){
        console.log('No devices');
        return;
    }
    
    newData = snapshot.data();

    const deviceIdTokens = await admin
        .firestore()
        .collection('DeviceTokens')
        .get();
 
    var tokens = [];
 
    for (var token of deviceIdTokens.docs) {
        tokens.push(token.data().token);
    }

    var payload = {
        notification: {
            title: 'Sunshine Laundry',
            body: 'Order Notification',
            sound: 'default',
        },
        data:{
            click_action : "FLUTTER_NOTIFICATION_CLICK", 
            id : newData.id,
            title: newData.title,           
            message: newData.message,                       
            latitude : newData.latitude,
            longitude : newData.longitude
        }
    };
 
    try {
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log('Notification sent successfully');
    } catch (err) {
        console.log(err);
    }

});

