const functions = require("firebase-functions");
const admin = require("firebase-admin")

admin.initializeApp()
const db = admin.firestore()
const fcm = admin.messaging()

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
exports.docAdded = functions.firestore.document('/users/{documentId}').onCreate(async (snapshot,context)=>{
    console.log(snapshot.data())
    return Promise.resolve()
})
exports.helloworld = functions.https.onRequest((req,res)=>{
    res.send('from hello world function houray 20001-cm-042')
})
exports.sendNotification = functions.firestore.document('/noti/{documentId}').onCreate(async(snapshot,context)=>{
    var message = snapshot.data()

    try{ 
        console.log(snapshot.data())
            //const querySnapshot = await db.collection('users').doc('vg8f6BN2QXMT6HLFeZXWlDT1DKg1').collection('tokens').get()
            const token = 'efDh7wyfRkyNhHSSSSfv3m:APA91bFEloKHKYrGvNw3nA26n5lC9GiqBrzLCfEerDlMruVzw_c8pKl8k-uMvXR4K6N-KKcpOvVLYVzln6xE6o1u6fWfTn0aspqcitP9t426oLyNaYMu8slYQkW1Ent7Um4aokLUUCNF'

            const payLoad = {
                notification: {
                    title: 'PersonalExpenseApp',
                    body: message.name,
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                },
            }

            return fcm.sendToDevice(token,payLoad);
    }catch(e){
        console.log(e.toString())
    }


})