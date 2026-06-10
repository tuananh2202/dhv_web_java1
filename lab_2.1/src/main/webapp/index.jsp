<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Máy tính JSP</title>

    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: #eee;
            font-family: Arial;
        }

        .calculator {
            background: #dcdcdc;
            padding: 10px;
            border-radius: 10px;
            width: 260px;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
        }

        #display {
            width: 100%;
            height: 50px;
            font-size: 26px;
            text-align: right;
            padding: 5px;
            margin-bottom: 10px;
            border: 1px solid #999;
            background: #f8f8f8;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            grid-auto-rows: 50px;
            gap: 5px;
        }

        button {
            font-size: 18px;
            border: 1px solid #888;
            background: #e6e6e6;
            cursor: pointer;
            border-radius: 5px;
        }

        button:hover {
            background: #ccc;
        }

        .operator {
            background: #d0d0d0;
        }

        .equal {
            grid-row: span 5;
            background: #bfbfbf;
            font-size: 22px;
        }

        .zero {
            grid-column: span 2;
        }
    </style>
</head>

<body>

<div class="calculator">
    <input type="text" id="display" value="0" readonly>

    <div class="grid">
        <button class="operator" onclick="press('+')">+</button>
        <button class="operator" onclick="press('-')">-</button>
        <button class="operator" onclick="press('*')">×</button>
        <button class="operator" onclick="press('/')">÷</button>

        <button onclick="press('7')">7</button>
        <button onclick="press('8')">8</button>
        <button onclick="press('9')">9</button>
        <button class="equal" onclick="calculate()">=</button>

        <button onclick="press('5')">5</button>
        <button onclick="press('6')">6</button>
        <button onclick="press('4')">4</button>

        <button onclick="press('1')">1</button>
        <button onclick="press('2')">2</button>
        <button onclick="press('3')">3</button>

        <button class="zero" onclick="press('0')">0</button>
        <button onclick="press('.')">.</button>
        <button onclick="clearDisplay()">AC</button>
    </div>
</div>

<script>
    let display = document.getElementById("display");

    function press(value) {
        if (display.value === "0") {
            display.value = value;
        } else {
            display.value += value;
        }
    }

    function clearDisplay() {
        display.value = "0";
    }

    function calculate() {
        try {
            display.value = eval(display.value);
        } catch (e) {
            display.value = "Error";
        }
    }
</script>

</body>
</html>
