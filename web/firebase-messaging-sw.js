importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyAOrw66o6qi2dMVYSHde6uT5MWuJtX7JXQ",
  authDomain: "notificao-push-43290.firebaseapp.com",
  databaseURL: "https://notificao-push-43290.firebaseapp.com",
  projectId: "notificao-push-43290",
  storageBucket: "notificao-push-43290.appspot.com",
  messagingSenderId: "1017543164770",
  appId: "1:1017543164770:web:5db41ebfea9cc4b9a2223b",
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});