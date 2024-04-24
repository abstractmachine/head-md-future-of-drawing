import pandas as pd
import argparse

def convert_tsv_to_csv(input_file, output_file):
    # Read the tsv file
    df = pd.read_csv(input_file, sep='\t')

    # For each row
    for index, row in df.iterrows():
        # Concatenate the text fields

        contexte = 'Ma couleur est ' + row['Couleur'] + '. ' + 'Mon objet est ' + row['Objet'] + '. ' + 'Mon contexte est ' + row['Contexte'] + '.'
        text = f"<s>[INST] {contexte} [/INST] {row['Phrases']} </s>"

        df.at[index, 'text'] = text

    # Drop the other columns
    df = df[['text']]

    # Write to csv
    df.to_csv(output_file, index=False)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Convert a tsv file to a csv file.')
    parser.add_argument('input_file', type=str, help='The input tsv file.')
    parser.add_argument('output_file', type=str, help='The output csv file.')
    args = parser.parse_args()

    convert_tsv_to_csv(args.input_file, args.output_file)