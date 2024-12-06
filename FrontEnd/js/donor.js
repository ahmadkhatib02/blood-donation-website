const submitEl = document.getElementById("submit-btn")
const submit = document.getElementById("submit")
const img = document.getElementById("img")
const form = document.querySelector("form")


submitEl.addEventListener("mouseover", function(){
    submitEl.style.backgroundColor="black"
    submitEl.style.cursor="pointer"
    submit.style.color="white"
    img.innerHTML=`<img src="images/check-circle-dark.png">`

})

submitEl.addEventListener("mouseout", function(){
    submitEl.style.backgroundColor="white"
    submit.style.color="black"
    img.innerHTML=`<img src="images/check-circle.png">`
})

// Add an event listener for form submission
form.addEventListener("submit", async (event) => {
    event.preventDefault(); // Prevent the form from refreshing the page

    // Collect form data
    const firstName = document.getElementById("firstName").value.trim();
    const lastName = document.getElementById("lastName").value.trim();
    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value;
    const gender = document.getElementById("gender").value;
    const city = document.getElementById("cities").value;
    // Validate form data
    if (!firstName || !lastName || !email || !password) {
        alert("Please fill in all the fields.");
        return;
    }

    try {
        // Send a POST request to the backend /register endpoint
        const response = await fetch("http://localhost:5000/register", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                firstName,
                lastName,
                email,
                password,
                gender,
                city
            })
        });

        const data = await response.json();

        if (response.ok) {
            alert(data.message); // Show success message
            // Redirect to the login page or another page
            window.location.href = "login.html";
        } else {
            alert(data.message || "Registration failed. Please try again.");
        }
    } catch (error) {
        console.error("Error:", error);
        alert("An error occurred. Please try again later.");
    }
})