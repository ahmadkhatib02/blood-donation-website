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