function csvToHtml(input) {
    if (!input || typeof input !== 'string') {
        throw new Error('Invalid input!');
    }

    function _createTableCell(cellContents, index) {
        if (!cellContents || typeof cellContents !== 'string') {
            throw new Error('Invalid data!');
        }

        const tableCell = document.createElement(
            (index === 0) ? 'th' : 'td'
        );

        tableCell.textContent = cellContents.trim();
        return tableCell;
    }

    const rows = input.split('\n');
    const table = document.createElement('table');

    rows.forEach((row, index) => {
        const tableRow = document.createElement('tr');
        const tableCells = row.split(',');

        tableCells.forEach((cell) => {
            try {
                tableRow.appendChild(
                    _createTableCell(cell, index),
                );
            } catch (error) {
                console.error(error);
            }
        });

        table.appendChild(tableRow);
    });

    return table;
}
