// Firebase initialization
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.3.0/firebase-app.js";
import { getFirestore, collection, getDocs } from "https://www.gstatic.com/firebasejs/10.3.0/firebase-firestore.js";

// Your Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyAZSKEdw0n52mHffa32cx3igFUW3A1O0XI",
    authDomain: "pet-application-final.firebaseapp.com",
    projectId: "pet-application-final",
    storageBucket: "pet-application-final.appspot.com",
    messagingSenderId: "179423395003",
    appId: "1:179423395003:web:f0421078594e6f7e963d9e",
    measurementId: "G-LHNTXM9PJ7",
};

// Initialize Firebase and Firestore
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// DOM Elements
const userList = document.getElementById("user-list");
const ownerPopup = document.getElementById("owner-popup");
const ownerName = document.getElementById("owner-name");
const ownerEmail = document.getElementById("owner-email");
const ownerPhone = document.getElementById("owner-phone");
const ownerAddress = document.getElementById("owner-address");
const petList = document.getElementById("pet-list");
const searchInput = document.getElementById("search-input");
const closePopupButton = document.querySelector(".close-popup");

// Fetch users from Firestore
async function fetchUsers() {
  try {
    const usersSnapshot = await getDocs(collection(db, "users"));
    if (usersSnapshot.empty) {
      console.log("No users found in Firestore.");
    } else {
      usersSnapshot.forEach((doc) => {
        const userData = doc.data(); // User top-level data
        if (userData) {
          const userCard = document.createElement("button");
          userCard.classList.add("user-card");

          // Fallback for missing fields
          const fullName = userData.fullName || "Unknown Name";
          const email = userData.email || "Unknown Email";
          const ownerPhone = userData.owner_phone || "Unknown Phone";
          const ownerAddress = userData.owner_address || "Unknown Address";

          userCard.innerHTML = `
            <h3>${fullName}</h3>
            <p>Email: ${email}</p>
          `;
          userCard.addEventListener("click", () => showOwnerDetails(doc.id, { fullName, email, ownerPhone, ownerAddress }));
          userList.appendChild(userCard);
        } else {
          console.log(User data missing for docId: ${doc.id});
        }
      });
    }
  } catch (error) {
    console.error("Error fetching users:", error);
  }
}

// Show owner details and their pets in the popup
async function showOwnerDetails(userId, user) {
  ownerName.textContent = user.fullName || "N/A";
  ownerEmail.textContent = user.email || "N/A";
  ownerPhone.textContent = user.ownerPhone || "N/A";
  ownerAddress.textContent = user.ownerAddress || "N/A";

  // Clear previous pet data
  petList.innerHTML = "";

  try {
    // Fetch pets subcollection
    const petsSnapshot = await getDocs(collection(db, users/${userId}/pets));
    if (petsSnapshot.empty) {
      petList.innerHTML = "<p>No pets available for this user.</p>";
    } else {
      petsSnapshot.forEach((petDoc) => {
        const petData = petDoc.data();

        // Fallbacks for missing pet fields
        const petName = petData.name || "Unknown Name";
        const petType = petData.type || "Unknown Type";
        const petBreed = petData.breed || "Unknown Breed";
        const petGender = petData.gender || "Unknown Gender";
        const petAge = petData.age || "Unknown Age";
        const petColor = petData.color || "Unknown Color";

        const petCard = document.createElement("div");
        petCard.classList.add("pet-card");
        petCard.innerHTML = `
          <h4>${petName}</h4>
          <p><strong>Type:</strong> ${petType}</p>
          <p><strong>Breed:</strong> ${petBreed}</p>
          <p><strong>Gender:</strong> ${petGender}</p>
          <p><strong>Age:</strong> ${petAge}</p>
          <p><strong>Color:</strong> ${petColor}</p>
        `;
        petList.appendChild(petCard);
      });
    }
  } catch (error) {
    console.error("Error fetching pets:", error);
    petList.innerHTML = <p>Unable to fetch pets.</p>;
  }

  // Show popup
  ownerPopup.style.display = "block";
}

// Close popup function
function closePopup() {
  ownerPopup.style.display = "none";
}

// Search filter
function filterUsers() {
  const input = searchInput.value.toLowerCase();
  const userCards = document.querySelectorAll(".user-card");
  userCards.forEach((card) => {
    const name = card.querySelector("h3").textContent.toLowerCase();
    if (name.includes(input)) {
      card.style.display = "";
    } else {
      card.style.display = "none";
    }
  });
}

// Event listeners
searchInput.addEventListener("keyup", filterUsers);
closePopupButton.addEventListener("click", closePopup);

// Initialize the app
fetchUsers();