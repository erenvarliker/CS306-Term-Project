///// User Authentication /////

const auth = firebase.auth();

const whenSignedIn = document.getElementById('whenSignedIn');
const whenSignedOut = document.getElementById('whenSignedOut');

const signInBtn = document.getElementById('signInBtn');
const guestSignInBtn = document.getElementById('guestSignInBtn');
const signOutBtn = document.getElementById('signOutBtn');

const userDetails = document.getElementById('userDetails');

/// Sign in event handlers

signInBtn.onclick = async () => {
  const email = document.getElementById('email').value;
  const password = document.getElementById('password').value;

  try {
    await auth.signInWithEmailAndPassword(email, password);
  } catch (error) {
    alert(`Error: ${error.message}`);
  }
};

guestSignInBtn.onclick = async () => {
  try {
    await auth.signInAnonymously();
  } catch (error) {
    alert(`Error: ${error.message}`);
  }
};

signOutBtn.onclick = () => auth.signOut();

/// Auth state change listener

auth.onAuthStateChanged(user => {
  if (user) {
    whenSignedIn.hidden = false;
    whenSignedOut.hidden = true;
    userDetails.innerHTML = `<h3>Hello ${user.email ? user.email : 'Guest'}</h3>`;
    loadThreads(user.uid);
  } else {
    whenSignedIn.hidden = true;
    whenSignedOut.hidden = false;
    userDetails.innerHTML = '';
    threadsList.innerHTML = '';
    messagesList.innerHTML = '';
    sendMessageForm.hidden = true;
  }
});

///// Firestore /////

const db = firebase.firestore();

const threadsList = document.getElementById('threadsList');
const messagesList = document.getElementById('messagesList');
const createThreadForm = document.getElementById('createThreadForm');
const sendMessageForm = document.getElementById('sendMessageForm');
const messageContent = document.getElementById('messageContent');

let threadsRef;
let messagesRef;
let unsubscribeThreads;
let unsubscribeMessages;

function loadThreads(uid) {
  threadsRef = db.collection('threads')

  unsubscribeThreads = threadsRef.onSnapshot(querySnapshot => {
    const items = querySnapshot.docs.map(doc => {
      return `<li data-id="${doc.id}">${doc.data().title}</li>`;
    });

    threadsList.innerHTML = items.join('');
    threadsList.querySelectorAll('li').forEach(item => {
      item.onclick = () => loadMessages(item.getAttribute('data-id'));
    });
  });
}

function loadMessages(threadId) {
  messagesRef = db.collection('threads').doc(threadId);
  const msgref = messagesRef.collection('messages').orderBy('timestamp');

  unsubscribeMessages && unsubscribeMessages();
  unsubscribeMessages = msgref.onSnapshot(querySnapshot => {
    const items = querySnapshot.docs.map(doc => {
      const data = doc.data();
      return `<li><strong>${data.sender}:</strong> ${data.content} <em>${data.timestamp ? new Date(data.timestamp.toDate()).toLocaleString() : 'No timestamp'}</em></li>`;
    });

    messagesList.innerHTML = items.join('');
    sendMessageForm.hidden = false;
    sendMessageForm.onsubmit = async (event) => {
      event.preventDefault();
      const content = messageContent.value.trim();
      if (content) {
        await messagesRef.collection('messages').add({
          sender: auth.currentUser.email || 'Guest',
          content: content,
          timestamp: firebase.firestore.FieldValue.serverTimestamp(),
          uid: auth.currentUser.uid
        });
        messageContent.value = '';
      }
    };
  });
}

createThreadForm.onsubmit = async (event) => {
  event.preventDefault();
  const title = document.getElementById('threadTitle').value;
  const initialMessage = document.getElementById('initialMessage').value;

  const newThreadRef = await db.collection('threads').add({
    uid: auth.currentUser.uid,
    title: title
  });

  await newThreadRef.collection('messages').add({
    sender: auth.currentUser.email || 'Guest',
    content: initialMessage,
    timestamp: firebase.firestore.FieldValue.serverTimestamp(),
    uid: auth.currentUser.uid
  });

  createThreadForm.reset();
};