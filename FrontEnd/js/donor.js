var submitEl = document.getElementById("submit-btn")
var submit = document.getElementById("submit")
var img = document.getElementById("img")
submitEl.addEventListener("mouseover", function(){
    submitEl.style.backgroundColor="black"
    submit.style.color="white"
    img.innerHTML=`<img src="images/check-circle-dark.png">`

})

submitEl.addEventListener("mouseout", function(){
    submitEl.style.backgroundColor="white"
    submit.style.color="black"
    img.innerHTML=`<img src="images/check-circle.png">`
})