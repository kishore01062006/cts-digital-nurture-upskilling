console.log("Welcome to the Community Portal");

window.onload = () => {
    alert("Page Fully Loaded");
};

let events = [

    {
        name: "Music Festival",
        category: "Music",
        seats: 20
    },

    {
        name: "Coding Workshop",
        category: "Workshop",
        seats: 15
    },

    {
        name: "Sports Meet",
        category: "Sports",
        seats: 10
    }

];

function displayEvents(list) {

    const container =
        document.querySelector("#eventContainer");

    container.innerHTML = "";

    list.forEach(event => {

        let card =
            document.createElement("div");

        card.className = "eventCard";

        card.innerHTML = `
        <h3>${event.name}</h3>
        <p>Category: ${event.category}</p>
        <p>Seats: ${event.seats}</p>
        <button onclick="registerUser('${event.name}')">
        Register
        </button>
        `;

        container.appendChild(card);
    });
}

displayEvents(events);

function registerUser(eventName) {

    try {

        let event =
            events.find(e => e.name === eventName);

        if (event.seats <= 0) {
            throw "No Seats Available";
        }

        event.seats--;

        alert("Registered Successfully");

        displayEvents(events);

    } catch (error) {
        alert(error);
    }
}

document
    .querySelector("#categoryFilter")
    .onchange = function() {

        let category = this.value;

        if (category === "All") {
            displayEvents(events);
        } else {

            let filtered =
                events.filter(
                    e => e.category === category);

            displayEvents(filtered);
        }
    };

document
    .querySelector("#searchBox")
    .addEventListener("keydown", () => {

        let text =
            document.querySelector("#searchBox")
            .value
            .toLowerCase();

        let result =
            events.filter(
                e => e.name.toLowerCase()
                .includes(text));

        displayEvents(result);
    });


function validatePhone() {

    let phone =
        document.querySelector("#phone").value;

    if (phone.length < 10) {
        alert("Invalid Phone Number");
    }
}

function showFee() {

    let type =
        document.querySelector("#eventType").value;

    let fee = 0;

    if (type === "Music") fee = 100;
    else if (type === "Workshop") fee = 200;
    else if (type === "Sports") fee = 150;

    document.querySelector("#fee")
        .innerText =
        "Fee: ₹" + fee;
}


function showConfirmation() {

    alert("Form Submitted");
}

function countCharacters() {

    let count =
        document.querySelector("#feedback")
        .value.length;

    document.querySelector("#charCount")
        .innerText =
        count + " Characters";
}

function enlargeImage(img) {

    img.style.width = "350px";
}

function videoReady() {

    document.querySelector("#videoMsg")
        .innerText =
        "Video Ready To Play";
}

document
    .querySelector("#eventForm")
    .addEventListener("submit",
        function(event) {

            event.preventDefault();

            let form = this;

            let name = form.elements["name"].value;

            document.querySelector("#output")
                .innerHTML =
                "Thank You " + name +
                " For Registering";

            fetch(
                "https://jsonplaceholder.typicode.com/posts", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },

                    body: JSON.stringify({
                        name: name
                    })
                })

            .then(response => response.json())

            .then(data => {
                console.log(data);
            })

            .catch(error => {
                console.log(error);
            });
        });

let eventType =
    localStorage.getItem("eventType");

if (eventType) {

    document.querySelector("#eventType")
        .value = eventType;
}

document
    .querySelector("#eventType")
    .addEventListener("change",
        function() {

            localStorage.setItem(
                "eventType",
                this.value);
        });

function findLocation() {

    navigator.geolocation.getCurrentPosition(

        position => {

            document.querySelector("#location")
                .innerText =

                `Latitude:
        ${position.coords.latitude}

        Longitude:
        ${position.coords.longitude}`;
        },

        error => {
            alert("Location Error");
        },

        {
            enableHighAccuracy: true,
            timeout: 5000
        }
    );
}

function warningMessage() {

    return "Are you sure you want to leave?";
}