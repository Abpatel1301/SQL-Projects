# Movie Correlation Project

This project explores correlations between various attributes of movies such as budget, gross earnings, and ratings using a dataset of movies. The analysis is performed using Python libraries such as pandas, numpy, seaborn, and matplotlib.

## Description

The Jupyter Notebook `Movie Correlation Project.ipynb` contains the following steps:
- Loading and inspecting the dataset
- Cleaning the data by handling missing values
- Performing exploratory data analysis (EDA) to identify correlations between different attributes of movies
- Visualizing the results using seaborn and matplotlib

## Prerequisites

To run the Jupyter Notebook, you need:
- Python 3.x
- Jupyter Notebook or JupyterLab
- The following Python libraries:
  - pandas
  - numpy
  - seaborn
  - matplotlib

## Installation

1. Clone the repository to your local machine:
    ```bash
    git clone https://github.com/your-username/Movie-Correlation-Project.git
    ```

2. Navigate to the project directory:
    ```bash
    cd Movie-Correlation-Project
    ```

3. Install the required libraries:
    ```bash
    pip install pandas numpy seaborn matplotlib
    ```

## Usage

1. Open Jupyter Notebook or JupyterLab:
    ```bash
    jupyter notebook
    ```

2. In the Jupyter Notebook interface, navigate to the project directory and open the `Movie Correlation Project.ipynb` file.

3. Run the cells in the notebook to perform the data analysis.

### Example Code

- **Loading the dataset:**
    ```python
    import pandas as pd
    import numpy as np
    import seaborn as sns
    import matplotlib.pyplot as plt

    df = pd.read_csv('movies.csv')
    df.head()
    ```

- **Handling missing data:**
    ```python
    # Loop through the data and see if there is anything missing
    for col in df.columns:
        percent_missing = np.mean(df[col].isnull())
        print('{} - {}%'.format(col, round(percent_missing*100)))

    # Impute missing 'budget' values based on the mean budget for movies of the same genre
    df['budget'] = df.groupby('genre')['budget'].transform(lambda x: x.fillna(x.mean()))

    # Drop rows with missing 'gross' and 'rating' values
    df = df.dropna(subset=['gross', 'rating'])
    ```

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes. Ensure your code follows the existing coding style and includes appropriate comments.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- Dataset sourced from [Kaggle](https://www.kaggle.com).

