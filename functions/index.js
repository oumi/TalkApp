const functions = require('firebase-functions');
const admin = require('firebase-admin');


admin.initializeApp(functions.config().firebase);

exports.sendNotification = functions.database
    .ref('/messages/{messageId}/{msgId}')
    .onWrite(event => {

        const snapshot = event.after;
      // const snapshot = event.data;

       const userId = snapshot.val().to;
       const userId2 = snapshot.val().from;


       const text = snapshot.val().text;

         return admin
        .database()
        .ref(`users/${userId2}`)
        .once('value')
        .then(data1 => {
    /*   const payload = {
                    notification: {
                      title: ${data1.val().name},
                      body: text
                        ? text.length <= 100 ? text : text.substring(0, 97) + "..."
                        : "",
                      tag : userId2,
                      click_action: 'FLUTTER_NOTIFICATION_CLICK'
                    }
                  };*/

         const payload = {
            notification: {
              title: `${data1.val().name}`,
              body: text
                ? text.length <= 100 ? text : text.substring(0, 97) + "..."
                : ""
            }
          };
          return admin
        .database()
        .ref(`users/${userId}`)
        .once('value')
        .then(data => {
          console.log('The user token', data.val().token);
          if (data.val().token) {
            return admin.messaging().sendToDevice(data.val().token, payload);
          }
        });


        });

});











// const functions = require('firebase-functions');
// const admin = require('firebase-admin');


// admin.initializeApp(functions.config().firebase);

// var msgData;

// exports.messageTrigger = functions.database
// .ref('/messages/{messageId}/{msgId}')
// .onCreate((snapshot, context) => {
//     msgData = snapshot.data();

//     admin.database()
//           .ref(`/users/${msgData.to}`).once('value').then((snapshot) => {
//             token = snapshot.data().token;
//             console.log(token);
//             var payload = {
//               "notification": {
//                 "title":"From" + msgData.from,
//                 "body":"Msg" + msgData.text,
//                 "sound":"default",
//               },
//               "data":{
//                 "sendername":msgData.from,
//                 "message":msgData.text
//             }
//             }
//             return admin.messaging().sendToDevice(token, payload).then((response)=>{
//               console.log(response);

//               console.log("Pushed them all");
//             }).catch((err)=>{
//               console.log(err);
//             })
//           });

//   admin.database.ref('/users/{msgData.to}')
//     .get().then((snapshot) => {
//     var token;
//     if (snapshot.empty) {
//       console.log("No Devices");
//     }else{
//       // for(var token of snapshots.docs){
//       //   tokens.push(token.data().token);
//       // }
//       token = snapshot.data().token;
//       console.log(token);


//       var payload = {
//         "notification": {
//           "title":"From" + msgData.from,
//           "body":"Msg" + msgData.text,
//           "sound":"default",
//         },
//         "data":{
//           "sendername":msgData.from,
//           "message":msgData.text
//       }
//       }

//       return admin.messaging().sendToDevice(token, payload).then((response)=>{
//         console.log("Pushed them all");
//       }).catch((err)=>{
//         console.log(err);
//       })

//     }
//   }).catch((err)=>{
//     console.log(err);
//   })
// })

