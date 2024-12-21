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

submitEl.addEventListener("click", function(){
    hcLogin()
})

function hcLogin() {
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    fetch('/health_Care_Professional/login', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ email: email, password: password })
    })
    .then(response => response.json())
    .then(data => {
        if (data.branch_ID) {
            // Store branch_ID in localStorage
            localStorage.setItem('branch_ID', data.branch_ID);
            console.log('Login successful, branch_ID stored:', data.branch_ID);
        } else {
            console.log('Login failed:', data.error.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
    });
}


