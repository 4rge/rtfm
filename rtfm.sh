<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>R.T.F.M.</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            padding: 0;
            background-color: #121212;
            color: #e0e0e0;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        h1 {
            color: #fff;
        }
        label {
            font-weight: bold;
        }
        textarea, input, select {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #555;
            border-radius: 8px;
            background-color: #222;
            color: #e0e0e0;
        }
        button {
            margin-top: 10px;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            background-color: #007bff;
            color: white;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        pre {
            background-color: #1e1e1e;
            padding: 10px;
            border: 1px solid #444;
            border-radius: 8px;
            white-space: pre-wrap;
            word-wrap: break-word;
            margin-top: 10px;
            margin-bottom: 20px;
            width: 100%;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            text-align: left;
            border: 1px solid #444;
            padding: 10px;
            background-color: #222;
        }
        th {
            color: #fff;
        }
    </style>
</head>
<body>

<h1>Man Page Generator</h1>

<table>
    <tr>
        <th style="width: 20%;">Field</th> <!-- Set width to 20% for the Field column -->
        <th>Input</th>
        <th>Include?</th>
    </tr>
    <tr>
        <td class="tooltip" style="width: 20%;">
            Program Name:
            <span class="tooltiptext">Enter the name of the program.</span>
        </td>
        <td><input type="text" id="program-name" value="your_program"></td>
        <td><input type="checkbox" id="include-program-name" checked></td>
    </tr>
    <tr>
        <td class="tooltip" style="width: 20%;">
            Description:
            <span class="tooltiptext">Short description of the program.</span>
        </td>
        <td><textarea id="description" rows="2" placeholder="Short description of the program."></textarea></td>
        <td><input type="checkbox" id="include-description" checked></td>
    </tr>
    <tr>
        <td class="tooltip" style="width: 20%;">
            Version:
            <span class="tooltiptext">Enter the version number of the program.</span>
        </td>
        <td><input type="text" id="version" placeholder="1.0.0"></td>
        <td><input type="checkbox" id="include-version" checked></td>
    </tr>
    <tr>
        <td class="tooltip" style="width: 20%;">
            Exit Status:
            <span class="tooltiptext">Description of the exit status of the program.</span>
        </td>
        <td><textarea id="exit-status" rows="2" placeholder="Description of exit status."></textarea></td>
        <td><input type="checkbox" id="include-exit-status" checked></td>
    </tr>
    <tr>
        <td class="tooltip" style="width: 20%;">
            Options:
            <span class="tooltiptext">Format: -o|Description|Type|Default</span>
        </td>
        <td><textarea id="options" rows="4" placeholder="-o|Output file|string|output.txt"></textarea></td>
        <td><input type="checkbox" id="include-options" checked></td>
    </tr>
    <tr>
        <td class="tooltip" style="width: 20%;">
            Date:
            <span class="tooltiptext">The date for the man page.</span>
        </td>
        <td><input type="text" id="date" value="" placeholder="YYYY-MM-DD" readonly></td>
        <td><input type="checkbox" id="include-date" checked></td>
    </tr>
</table>

<h2>Generated Man Page:</h2>
<pre id="output"></pre>

<div style="display: flex; justify-content: space-around; width: 100%;">
    <button onclick="generateManPage()">Generate Man Page</button>
    <button onclick="copyToClipboard()">Copy to Clipboard</button>
    <button onclick="downloadManPage()">Download Man Page</button>
</div>

<p style="margin-top: 20px;">To convert the generated man page to a formatted output, use the following command:</p>
<pre>groff -Tascii -man &lt;your_program.1&gt; &gt; &lt;output_file.txt&gt;</pre>

<script>
    // Set the current date
    document.getElementById('date').value = new Date().toISOString().split('T')[0];

    function generateManPage() {
        let manPageContent = '';
        
        if (document.getElementById('include-program-name').checked) {
            const programName = document.getElementById('program-name').value;
            manPageContent += `.TH ${programName.toUpperCase()} 1 "${document.getElementById('date').value}" "${document.getElementById('version').value}" "${programName} manual"\n`;
        }
        
        if (document.getElementById('include-description').checked) {
            const description = document.getElementById('description').value;
            manPageContent += `.SH NAME\n${document.getElementById('program-name').value} - ${description}\n`;
        }

        if (document.getElementById('include-program-name').checked) {
            manPageContent += `.SH SYNOPSIS\n.B ${document.getElementById('program-name').value}\n`;
        }

        if (document.getElementById('include-description').checked) {
            manPageContent += '.SH DESCRIPTION\n' + (document.getElementById('description').value || '') + '\n';
        }

        if (document.getElementById('include-exit-status').checked) {
            manPageContent += '.SH EXIT STATUS\n' + (document.getElementById('exit-status').value || '') + '\n';
        }

        // Process options
        if (document.getElementById('include-options').checked) {
            const optionsInput = document.getElementById('options').value.split('\n');
            if (optionsInput.length > 0) {
                manPageContent += '.SH OPTIONS\n';
                optionsInput.forEach(option => {
                    const parts = option.split('|');
                    if (parts.length > 0) {
                        manPageContent += `\n.B ${parts[0]}\n${parts[1] || ''}\n`;
                        if (parts.length > 2) manPageContent += `Type: ${parts[2]}\n`;
                        if (parts.length > 3) manPageContent += `Default: ${parts[3]}\n`;
                    }
                });
            }
        }
        
        if (document.getElementById('include-date').checked) {
            manPageContent += `.SH DATE\n${document.getElementById('date').value}\n`;
        }

        document.getElementById('output').innerText = manPageContent.trim();
    }
    
    function copyToClipboard() {
        const output = document.getElementById('output');
        const textarea = document.createElement('textarea');
        textarea.value = output.innerText;
        document.body.appendChild(textarea);
        textarea.select();
        document.execCommand('copy');
        document.body.removeChild(textarea);
        alert('Copied to clipboard!');
    }

    function downloadManPage() {
        const output = document.getElementById('output').innerText;
        const blob = new Blob([output], { type: 'text/plain' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `${document.getElementById('program-name').value}.1`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    }
</script>

</body>
</html>
