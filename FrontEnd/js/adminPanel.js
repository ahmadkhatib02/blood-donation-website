const statusbtn = document.getElementsByClassName("statusbtn")

for(let i = 0 ; i<statusbtn.length; i++){
    statusbtn[i].addEventListener("click", function(){
        window.location.href = "form.html"
    })
}