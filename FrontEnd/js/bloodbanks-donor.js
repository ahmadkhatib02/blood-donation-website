const redCross= document.getElementById("selection1")
const hospital= document.getElementById("selection2")
const buttons = document.querySelector(".buttons")
const contact = document.getElementsByClassName("Contact")
const name = document.getElementsByClassName("name")
const adress = document.getElementsByClassName("adress")
let booking = new Object();

redCross.addEventListener("click",function(){
    //styling
    redCross.style.backgroundColor="black"
    redCross.style.borderRadius="30px"
    redCross.style.color="white"
    redCross.style.padding="13px 23px"
    
    hospital.style.backgroundColor="white"
    hospital.style.borderRadius="0px"
    hospital.style.color="black"
    hospital.style.padding="0px"

    buttons.style.padding="10px 26px 10px 0px"

    //adding the content

})

hospital.addEventListener("click",function(){
    //styling
    hospital.style.backgroundColor="black"
    hospital.style.borderRadius="30px"
    hospital.style.color="white"
    hospital.style.padding="13px 23px"
    
    redCross.style.backgroundColor="white"
    redCross.style.borderRadius="0px"
    redCross.style.color="black"
    redCross.style.padding="0px"

    buttons.style.padding="10px 0px 10px 26px"

    //adding the content
    
})

for(let i=0; i<contact.length; i++){
    contact[i].addEventListener("click",function(){
        book(booking,name[i].innerText, adress[i].innerText)
        window.location.href="homePage.html"
    })
}

function book (booking, name, adress){
    booking["name"]= name
    booking["adress"]= adress
    console.log(booking)
}