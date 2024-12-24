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
  } else {
    whenSignedIn.hidden = true;
    whenSignedOut.hidden = false;
    userDetails.innerHTML = '';
  }
});

///// Firestore /////

const db = firebase.firestore();

const createThing = document.getElementById('createThing');
const thingsList = document.getElementById('thingsList');

let thingsRef;
let unsubscribe;

auth.onAuthStateChanged(user => {
  if (user) {
    // Database Reference
    thingsRef = db.collection('things');

    createThing.onclick = () => {
      const { serverTimestamp } = firebase.firestore.FieldValue;

      thingsRef.add({
        uid: user.uid,
        name: faker.commerce.productName(),
        createdAt: serverTimestamp()
      });
    };

    // Query
    unsubscribe = thingsRef
      .where('uid', '==', user.uid)
      .orderBy('createdAt') // Requires a query
      .onSnapshot(querySnapshot => {
        // Map results to an array of li elements
        const items = querySnapshot.docs.map(doc => {
          return `<li>${doc.data().name}</li>`;
        });

        thingsList.innerHTML = items.join('');
      });
  } else {
    // Unsubscribe when the user signs out
    unsubscribe && unsubscribe();
  }
});

/// clear items on sign out