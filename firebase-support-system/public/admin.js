// Firebase Configuration
const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_AUTH_DOMAIN",
    databaseURL: "YOUR_DATABASE_URL",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_STORAGE_BUCKET",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    appId: "YOUR_APP_ID"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
const db = firebase.database();

// Get the admin chat box element
const adminChatBox = document.getElementById("admin-chat-box");

// Listen for messages from all users
db.ref("messages").on("value", (snapshot) => {
    // Clear the chat box
    adminChatBox.innerHTML = "";

    // Iterate through each user
    snapshot.forEach((userSnapshot) => {
        const userId = userSnapshot.key;

        // Iterate through each message for the user
        userSnapshot.forEach((messageSnapshot) => {
            const messageData = messageSnapshot.val();

            // Create a chat message element
            const messageElement = document.createElement("div");
            messageElement.innerHTML = `
                <p><strong>${messageData.name} (${messageData.subject}):</strong></p>
                <p>${messageData.message}</p>
                <p><small>${new Date(messageData.timestamp).toLocaleString()}</small></p>
                <hr>
            `;
            adminChatBox.appendChild(messageElement);
        });
    });
});
