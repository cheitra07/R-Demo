Set objExcel = CreateObject("Excel.Application")
objExcel.Visible = True

' Use the full path for the CSV file
Set objWorkbook = objExcel.Workbooks.Open("D:/2024-D/Interview Prep 2024/Rshiny-remote-role/R-Demo/sales-escalation/data/sales_data.csv")

' Save as XLSX
objWorkbook.SaveAs "D:/2024-D/Interview Prep 2024/Rshiny-remote-role/R-Demo/sales-escalation/data/sales_data.xlsx", 51
objExcel.Quit

