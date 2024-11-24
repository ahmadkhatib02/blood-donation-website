const submitEl= document.getElementById("submit-el")

submitEl.addEventListener("mouseover", function(){
    submitEl.style.backgroundColor= "black"
    submitEl.style.color="white"
    submitEl.style.cursor="pointer"
})

submitEl.addEventListener("mouseout", function(){
    submitEl.style.backgroundColor= "white"
    submitEl.style.color="black"
})