// Firebase configuration (ensure this is present at the top of your script)
const firebaseConfig = {
  apiKey: "AIzaSyAZSKEdw0n52mHffa32cx3igFUW3A1O0XI",
  authDomain: "pet-application-final.firebaseapp.com",
  projectId: "pet-application-final",
  storageBucket: "pet-application-final.appspot.com",
  messagingSenderId: "179423395003",
  appId: "1:179423395003:web:f0421078594e6f7e963d9e",
  measurementId: "G-LHNTXM9PJ7"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

// Initialize Firestore
const db = firebase.firestore();

// Fetch dashboard data function
async function fetchDashboardData() {
  try {
    const totalUsersElement = document.getElementById('totalUsers');
    const todaysAppointmentsElement = document.getElementById('todaysAppointments');
    const upcomingAppointmentsElement = document.getElementById('upcomingAppointments');
    const todaysAppointmentsDetails = document.getElementById('todaysAppointmentsDetails');
    const upcomingAppointmentsDetails = document.getElementById('upcomingAppointmentsDetails');

    // Clear previous data
    todaysAppointmentsDetails.innerHTML = '';
    upcomingAppointmentsDetails.innerHTML = '';
    todaysAppointmentsElement.textContent = '0';
    upcomingAppointmentsElement.textContent = '0';

    const today = new Date().toISOString().split('T')[0]; // Get today's date in YYYY-MM-DD format

    // Fetch total users
    const usersSnapshot = await db.collection('users').get();
    totalUsersElement.textContent = usersSnapshot.size; // Set total users count

    let todaysAppointmentsCount = 0;
    let upcomingAppointmentsCount = 0;

    // Loop through users and fetch their appointments
    for (const userDoc of usersSnapshot.docs) {
      const userId = userDoc.id;

      // Fetch appointments for each user with filters for 'upcoming' and 'today'
      const appointmentsSnapshot = await db
        .collection(users/${userId}/appointments)
        .where('status', 'in', ['upcoming', 'today']) // Fetch only 'upcoming' and 'today' statuses
        .get();

      appointmentsSnapshot.forEach((appointmentDoc) => {
        const appointmentData = appointmentDoc.data();
        const appointmentDate = appointmentData.day || ''; // Safeguard for missing 'day'
        const appointmentStatus = appointmentData.status || 'No Status'; // Safeguard for missing 'status'

        const appointmentHTML = `
          <div class="appointment-card">
            <h4>${appointmentData.appointment_name || 'No Name'}</h4>
            <p>Pet: ${appointmentData.pet || 'No Pet'}</p>
            <p>Service: ${appointmentData.service || 'No Service'}</p>
            <p>Date: ${appointmentDate}</p>
            <p>Time: ${appointmentData.time_slot || 'No Time'}</p>
            <p>Status: ${appointmentStatus}</p>
          </div>
        `;

        // Append to respective sections and update counts
        if (appointmentStatus === 'today') {
          todaysAppointmentsDetails.innerHTML += appointmentHTML;
          todaysAppointmentsCount++;
        } else if (appointmentStatus === 'upcoming') {
          upcomingAppointmentsDetails.innerHTML += appointmentHTML;
          upcomingAppointmentsCount++;
        }
      });
    }

    // Update counts in the dashboard cards
    todaysAppointmentsElement.textContent = todaysAppointmentsCount;
    upcomingAppointmentsElement.textContent = upcomingAppointmentsCount;
  } catch (error) {
    console.error('Error fetching dashboard data:', error);
    alert('Failed to load appointments. Please try again later.');
  }
}

// Call the function on page load
fetchDashboardData();