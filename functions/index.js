const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

exports.sendNotification = functions.database
    .ref('/messages/{messageId}/{msgId}')
    .onWrite(event => {
    //catch the message data
        const snapshot = event.after;
        console.log('inside');
        const receiver = snapshot.val().to;
        const sender = snapshot.val().from;
        const textMessage = snapshot.val().text;
        const fileMessage = snapshot.val().fileUrl;
        const imageMessage = snapshot.val().imageUrl;
         console.log('to ', receiver);
         console.log('from ', sender);
         console.log('text  ', textMessage);
        return admin
              .database()
              .ref(`users/${sender}`)
              .once('value')
              .then(senderData => {
                    const payload = {
                      notification: {
                        title: `${senderData.val().name}`,
                        body: textMessage
                          ? textMessage.length <= 100 ? textMessage : textMessage.substring(0, 97) + "..."
                          : (fileMessage|| imageMessage)? 'Envío realizado' :"",
                          tag: receiver,
                          click_action: 'FLUTTER_NOTIFICATION_CLICK'
                         }
                    };
                  return admin
                       .database()
                       .ref(`users/${receiver}`)
                       .once('value')
                       .then(receiverData => {
                               if (receiverData.val().token) {
                                           console.log('user token', receiverData.val().token);
                                           return admin.messaging().sendToDevice(receiverData.val().token, payload);
                                }else {
									return null;
								}
                             });
         });
    });