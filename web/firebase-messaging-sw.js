importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyCSHlZUKW4ElqMFw9uQDoWRzd5xNymCQuc",
      authDomain: "klixstorelb-42edc.firebaseapp.com",
      projectId: "klixstorelb-42edc",
      storageBucket: "klixstorelb-42edc.firebasestorage.app",
      messagingSenderId: "147411016956",
      appId: "1:147411016956:web:91c5046f6ba07fe7e74b79",
      measurementId: "G-9D9XQGHVX4"
});

const messaging = firebase.messaging();
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});