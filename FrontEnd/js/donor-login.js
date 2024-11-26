const submitEl = document.getElementById("submit-btn")
const submit = document.getElementById("submit")
const img = document.getElementById("img")
const form = document.querySelector("form")
const emailInput = document.getElementById("email")
const passwordInput = document.getElementById("password")

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

document.addEventListener('DOMContentLoaded', () => {
    form.addEventListener('submit', async (event) => {
        // Prevent form from submitting the default way
        event.preventDefault()

        // Get form values
        const email = emailInput.value.trim()
        const password = passwordInput.value;

        // Basic validation
        if (!email || !password) {
            alert('Please fill in all fields.')
            return;
        }

        // Disable the submit button to prevent multiple clicks
        submitEl.disabled = true;

        try {
            // Send POST request to the backend
            const response = await fetch('http://localhost:5000/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ email, password }),
            });

            const data = await response.json()

            if (response.ok) {
                // Login successful
                alert('Login successful!')
                // Redirect to bloodbanks.html
                window.location.href = 'bloodbanks.html'
            } else {
                // Login failed
                alert(data.message || 'Login failed. Please try again.')
            }
        } catch (error) {
            console.error('Error:', error);
            alert('An error occurred. Please try again later.')
        } finally {
            // Re-enable the submit button
            submitEl.disabled = false
        }
    });
});
