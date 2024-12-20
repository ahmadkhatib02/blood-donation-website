const submitEl= document.getElementById("submit-el")
const form = document.getElementById("form")

submitEl.addEventListener("mouseover", function(){
    submitEl.style.backgroundColor= "black"
    submitEl.style.color="white"
    submitEl.style.cursor="pointer"
})

submitEl.addEventListener("mouseout", function(){
    submitEl.style.backgroundColor= "white"
    submitEl.style.color="black"
})

form.addEventListener("submit", async (event) => {
    event.preventDefault(); // Prevent the form from refreshing the page

    // Collect form data
    
    const firstName = document.getElementById("firstName").value.trim();
    const lastName = document.getElementById("lastName").value.trim();
    const email = document.getElementById("email").value.trim();
    const bloodGroup = document.getElementById("bloodGroup").value;
    
    // Validate form data 
    if (!firstName || !lastName || !email || !bloodGroup) {
        alert("Please fill in all the fields.");
        return;
    }

    try {
        // Send a POST request to the backend /register endpoint
        const response = await fetch("http://localhost:5000/add_recipient", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                email,
                blood_type: bloodGroup,
                firstName,
                lastName,

            })
        });

        const data = await response.json();

        if (response.ok) {
            alert(data.message); // Show success message
            // Redirect to the login page or another page
            window.location.href = "bloodbanks.html";
        } else {
            alert(data.message || "Registration failed. Please try again.");
        }
    } catch (error) {
        console.error("Error:", error);
        alert("An error occurred. Please try again later.");
    }
})