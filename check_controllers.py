import pandas as pd

df = pd.read_excel('matlab/controller_results1.xlsx')

min_value = df['max_control_effort'].min()

min_rows = df[df['max_control_effort'] == min_value]

print(min_rows)