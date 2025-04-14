<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Employee Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        .dropdown {
            position: relative;
            display: inline-block;
        }
        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f9f9f9;
            border-radius: 10px;
            min-width: 300px; /* Increased width to accommodate input field */
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            padding: 12px 16px;
            z-index: 1;
        }
        .dropdown-content input[type="text"] {
            margin-bottom: 8px;
            display: block;
        }
        .dropdown-content label {
            display: block;
        }
        .filter-options {
            margin-left: 20px;
        }
        .scroll {
            margin: 4px;
            padding: 4px;
            width: 250px;
            height: 220px;
            border-top-right-radius: 10px;
            border-bottom-right-radius: 10px;
            overflow-x: hidden;
            overflow-y: auto;
            text-align: justify;
            scrollbar-width: thin;

        }

    </style>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <link href="Style.css" rel="stylesheet">
    <script>
        function handleSelectChange() {
            var selectElement = document.getElementById('documentType');
            var selectedOption = selectElement.value;
            if (selectedOption) {
                var form = document.getElementById('columnForm');
                var formData = new FormData(form);

                // Append the input fields to the formData
                var checkboxes = document.querySelectorAll("input[name='columns']");
                checkboxes.forEach(function(checkbox) {
                    if (checkbox.checked) {
                        var inputField = document.getElementById('search_' + checkbox.value);
                        var filterOption = document.querySelector('input[name="filter_' + checkbox.value + '"]:checked');
                        formData.append(checkbox.value, inputField.value);
                        formData.append('filter_' + checkbox.value, filterOption ? filterOption.value : '');
                    }
                });

                var url = selectedOption + '?' + new URLSearchParams(formData);
                window.open(url, '_blank');
            }
        }

        function toggleDropdown(event) {
            event.preventDefault();
            var checkboxes = document.getElementById('checkboxes');
            checkboxes.style.display = checkboxes.style.display === 'block' ? 'none' : 'block';
        }

        window.onclick = function(event) {
            var checkboxes = document.getElementById('checkboxes');
            if (!event.target.matches('.dropbtn') && !event.target.closest('.dropdown-content')) {
                if (checkboxes.style.display === 'block') {
                    checkboxes.style.display = 'none';
                }
            }
        };

        window.onload = function() {
            var dropdown = document.querySelector('.dropbtn');
            dropdown.addEventListener('click', toggleDropdown);

            var checkboxes = document.querySelectorAll("input[name='columns']");
            checkboxes.forEach(function(checkbox) {
                checkbox.addEventListener('change', function() {
                    var inputField = document.getElementById('search_' + this.value);
                    var filterOptions = document.querySelectorAll('.filter_' + this.value);
                    if (this.checked) {
                        inputField.style.display = "block";
                        filterOptions.forEach(function(option) {
                            option.style.display = "block";
                        });
                    } else {
                        inputField.style.display = "none";
                        filterOptions.forEach(function(option) {
                            option.style.display = "none";
                        });
                    }
                });
            });
        }
    </script>
</head>
<body class="bg-dark p-3">
<div class="text-light">
<div class="example-container">

<div class="example-row">
    <div class="example-content-main">
<form id="columnForm">
    <div class="dropdown">
        <button class="dropbtn btn btn-secondary">Select columns to show:</button>
        <div id="checkboxes" class="dropdown-content bg-secondary scroll">
            <label><input type="checkbox" name="columns" value="column1" checked>No</label>
            <input type="text" id="search_column1" name="search_column1" placeholder="Search No" style="display:block">
            <div class="filter-options filter_column1" style="display:block">
                <label><input type="radio" name="filter_column1" value="startsWith" checked> Starts with</label>
                <label><input type="radio" name="filter_column1" value="endsWith"> Ends with</label>
                <label><input type="radio" name="filter_column1" value="contains"> Contains</label>
            </div>

            <label><input type="checkbox" name="columns" value="column2" checked>Birth Date</label>
            <input type="date" id="search_column2" name="search_column2" placeholder="Search Birth Date" style="display:block">
            <div class="filter-options filter_column2" style="display:block">
                <label><input type="radio" name="filter_column2" value="startsWith" checked> Starts with</label>
                <label><input type="radio" name="filter_column2" value="endsWith"> Ends with</label>
                <label><input type="radio" name="filter_column2" value="contains"> Contains</label>
            </div>

            <label><input type="checkbox" name="columns" value="column3" checked>First Name</label>
            <input type="text" id="search_column3" name="search_column3" placeholder="Search First Name" style="display:block">
            <div class="filter-options filter_column3" style="display:block">
                <label><input type="radio" name="filter_column3" value="startsWith" checked> Starts with</label>
                <label><input type="radio" name="filter_column3" value="endsWith"> Ends with</label>
                <label><input type="radio" name="filter_column3" value="contains"> Contains</label>
            </div>

            <label><input type="checkbox" name="columns" value="column4" checked>Last Name</label>
            <input type="text" id="search_column4" name="search_column4" placeholder="Search Last Name" style="display:block">
            <div class="filter-options filter_column4" style="display:block">
                <label><input type="radio" name="filter_column4" value="startsWith" checked> Starts with</label>
                <label><input type="radio" name="filter_column4" value="endsWith"> Ends with</label>
                <label><input type="radio" name="filter_column4" value="contains"> Contains</label>
            </div>

            <label><input type="checkbox" name="columns" value="column5" checked>Gender</label>
            <select id="search_column5" name="search_column5" style="display:block">
                <option value="">Both</option>
                <option value="M">M</option>
                <option value="F">F</option>
            </select>

            <label><input type="checkbox" name="columns" value="column6" checked>Hire Date</label>
            <input type="date" id="search_column6" name="search_column6" placeholder="Search Hire Date" style="display:block">
            <div class="filter-options filter_column6" style="display:block">
                <label><input type="radio" name="filter_column6" value="startsWith" checked> Starts with</label>
                <label><input type="radio" name="filter_column6" value="endsWith"> Ends with</label>
                <label><input type="radio" name="filter_column6" value="contains"> Contains</label>
            </div>

            <label><input type="checkbox" name="columns" value="column7" checked>Dept</label>
            <input type="text" id="search_column7" name="search_column7" placeholder="Search Dept" style="display:block">
            <div class="filter-options filter_column7" style="display:block">
                <label><input type="radio" name="filter_column7" value="startsWith" checked> Starts with</label>
                <label><input type="radio" name="filter_column7" value="endsWith"> Ends with</label>
                <label><input type="radio" name="filter_column7" value="contains"> Contains</label>
            </div>

            <label><input type="checkbox" name="columns" value="column8" checked>Title</label>
            <input type="text" id="search_column8" name="search_column8" placeholder="Search Title" style="display:block">
            <div class="filter-options filter_column8" style="display:block">
                <label><input type="radio" name="filter_column8" value="startsWith" checked> Starts with</label>
                <label><input type="radio" name="filter_column8" value="endsWith"> Ends with</label>
                <label><input type="radio" name="filter_column8" value="contains"> Contains</label>
            </div>

        </div>
    </div>
</form>
</div>
<br>
    <div class="example-content-secondary">

<select id="documentType" class="btn bg-secondary text-light">
    <option value="">Select report type</option>
    <option value="Employee PDF">Create PDF</option>
    <option value="Employee XLSX">Create XLSX</option>
    <option value="Employee HTML">Create HTML</option>
</select>
        <br><br>

    </div>
</div>
</div>
    <center><button type="button" class="btn btn-outline-light bg-secondary text-light" onclick="handleSelectChange()">Generate Report</button></center>
    </div>

</body>
</html>
