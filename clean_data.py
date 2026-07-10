import pandas as pd

# Read the CSV file
df = pd.read_csv('Car Sales.csv', encoding='utf-8')

# Specify the column you want to correct
column_to_correct = 'Engine'

# Replace "Double Overhead" with "DoubleÂ Overhead"
df[column_to_correct] = df[column_to_correct].str.replace('Double Overhead', 'DoubleÂ Overhead')

date_column = 'Date'

# Convert dates from / to -
df[date_column] = pd.to_datetime(df[date_column].str.replace('/', '-'))


# Save the corrected data back to the CSV file
df.to_csv('Car Sales.csv', index=False, encoding='utf-8')

