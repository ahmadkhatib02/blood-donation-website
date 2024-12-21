const submitEl = document.getElementById("submit-btn");
const submit = document.getElementById("submit");
const form = document.querySelector("form");

submitEl.addEventListener("mouseover", function () {
    submitEl.style.backgroundColor = "black";
    submitEl.style.cursor = "pointer";
    submit.style.color = "white";
    img.innerHTML = `<img src="images/check-circle-dark.png">`;
});

submitEl.addEventListener("mouseout", function () {
    submitEl.style.backgroundColor = "white";
    submit.style.color = "black";
    img.innerHTML = `<img src="images/check-circle.png">`;
});

form.addEventListener("submit", async (event) => {
    event.preventDefault();
    const appointment_Date = document.getElementById("firstDate").value;
    const sobriety = document.getElementById("sobriety").value;
    const last_donated_date = document.getElementById("lastDate").value;
    const disease = document.getElementById("disease").value;
    const hemoglobin = document.getElementById("hemoglobin").value;
    const iron_levels = document.getElementById("iron").value;
    const isQualified = document.getElementById("qualified").value;

    try {
        // Send POST request to the backend
        const response = await fetch('http://localhost:5000/add_blood_sample_test', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                appointment_Date,
                sobriety,
                last_donated_date,
                disease,
                hemoglobin,
                iron_levels,
                isQualified
            }),
        });

        const data = await response.json();

        if (response.ok) {
            
            alert('Form Submitted');
            
            window.location.href = 'organizationPanel.html';
        } else {
            
            alert(data.message || 'Form Failed. Please try again.');
        }
    } catch (error) {
        console.error('Error:', error);
        alert('An error occurred. Please try again later.');
    } finally {
        // Re-enable the submit button
        submitEl.disabled = false;
    }
});
