#!/usr/bin/env python
# coding: utf-8

# In[4]:


import pandas as pd
import numpy as np
import matplotlib as plt 
import seaborn as sns
# Reading the loan prediction csv file 
train_data = pd.read_csv("Train.csv", low_memory = False)

# Reading the Holdout testing file
test_data = pd.read_csv("Test.csv", low_memory = False)

# Displaying the Loan prediction train data
train_data.head()


# 5 rows x 14 column

# In[5]:


# Displaying the Holdout testing file
test_data.head()


# In[6]:


train_data.describe()


# 5 rows x 13 column

# In[7]:


# Checking the null values in our train dataset through heat map

import seaborn as sns
sns.heatmap(train_data.isnull(), cbar=False)


# In[8]:


# Checking the null values in our test dataset through heat map

import seaborn as sns
sns.heatmap(test_data.isnull(), cbar=False)


# In[9]:


# Creating a function to find the missing values in columns
def missing_values_table(df):
    
        # Total missing values
        mis_val = df.isnull().sum()
        
        # Percentage of missing values
        mis_val_percent = 100 * df.isnull().sum() / len(df)
        
        # Make a table with the results
        mis_val_table = pd.concat([mis_val, mis_val_percent], axis=1)
        
        # Rename the columns
        mis_val_table_ren_columns = mis_val_table.rename(
        columns = {0 : 'Missing Values', 1 : '% of Total Values'})
        
        # Sort the table by percentage of missing descending
        mis_val_table_ren_columns = mis_val_table_ren_columns[
            mis_val_table_ren_columns.iloc[:,1] != 0].sort_values(
        '% of Total Values', ascending=False).round(1)
        
        # Print some summary information
        print ("Your selected dataframe has " + str(df.shape[1]) + " columns.\n"      
            "There are " + str(mis_val_table_ren_columns.shape[0]) +
              " columns that have missing values.")
        
        # Return the dataframe with missing information
        return mis_val_table_ren_columns


# In[10]:


# Call the above function and passing the train dataset as parameter
missing_values_table(train_data)


# In[11]:


# Call the above function and passing the train dataset as parameter
missing_values_table(test_data)


# Now, its time for some data cleaning. Before handling the missing values we will first remove the unwanted columns from our dataset which does not provide any insights. We will closely observe each columns and make decisions to remove or not.
# 
# From the above table we can see that there are three columns having more than 50% of missing values. We can simply drop these columns as they do not bring any valuable information.
# 
# We can see from above, our original dataset dimension have reduced. There are other columns as well which are not relevant and did not give much information. We will remove those columns as well.
# 
# Loan_Id - It is a unique id. Dropping it.

# In[12]:


# Removing the columns with up to 50% null and Loan_ID from our train dataset and renaming our new dataset
drop_cols = ['Loan_ID', 'Months_Since_Deliquency']
cleaned_train = train_data.drop(drop_cols, axis = 1)

# Removing the same columns on my test dataset and renaming it.
cleaned_test = test_data.drop(drop_cols, axis = 1)

#Checking the cleaned train file
cleaned_train.head()


# In[13]:


#Checking the cleaned test file
cleaned_test.head()


# In[14]:


# Finding the number of null values in each column
null_counts = cleaned_train.isnull().sum()
print("Number of null values in each column:\n{}".format(null_counts))


# In[15]:


# Finding the number of null values in each column
null_counts = cleaned_test.isnull().sum()
print("Number of null values in each column:\n{}".format(null_counts))


# In[16]:


# Checking value counts before filling NA
cleaned_train['Home_Owner'].value_counts()


# In[17]:


# Checking value counts before filling NA
cleaned_test['Home_Owner'].value_counts()


# Filling the NA values in column 'Home_Owner' with Mortgage as it is the higher frequency variable in the column.

# In[18]:


# Filling NA with Mortgage
cleaned_train['Home_Owner'] = cleaned_train['Home_Owner'].fillna('Mortgage')
cleaned_test['Home_Owner'] = cleaned_test['Home_Owner'].fillna('Mortgage')

# Checking value counts after filling NA
cleaned_train['Home_Owner'].value_counts()


# In[19]:


# Filling NA values with median
cleaned_train['Annual_Income'] = cleaned_train['Annual_Income'].fillna(value=cleaned_train["Annual_Income"].mean())
cleaned_test['Annual_Income'] = cleaned_test['Annual_Income'].fillna(value=cleaned_test["Annual_Income"].mean())


# In[20]:


# Checking value counts before filling NA
cleaned_train['Length_Employed'].value_counts()


# Cleaning the 'Length_Employed' by replacing less than 1year to 0.5 because it is the minimum requirement to apply for a loan. Moreover, removing years, year and + sign from the column and filling our NA values with the mean because the average interest rate for less than 1 year and 1 year is same.

# In[21]:


# Cleaning the train file
cleaned_train['Length_Employed'] = cleaned_train['Length_Employed'].str.replace('< 1 year','0.5').str.replace('years', '').str.replace('year', '').str.replace('+','')

# Cleaing the test file
cleaned_test['Length_Employed'] = cleaned_test['Length_Employed'].str.replace('< 1 year','0.5').str.replace('years', '').str.replace('year', '').str.replace('+','')

cleaned_train.head()


# In[22]:


cleaned_train.info()


# In[23]:


cleaned_test.info()


# In[24]:


# Cleaning the train file
cleaned_train['Loan_Amount_Requested'] = cleaned_train['Loan_Amount_Requested'].str.replace(',','')
cleaned_test['Loan_Amount_Requested'] = cleaned_test['Loan_Amount_Requested'].str.replace(',','')


# In[25]:


# Changing the dataype of Objects to float, str and int accordingly in train file
cleaned_train['Loan_Amount_Requested'] = cleaned_train['Loan_Amount_Requested'].astype(int)
cleaned_train['Length_Employed'] = cleaned_train['Length_Employed'].astype(float)
cleaned_train['Income_Verified'] = cleaned_train['Income_Verified'].astype(str)
cleaned_train['Purpose_Of_Loan'] = cleaned_train['Purpose_Of_Loan'].astype(str)
cleaned_train['Gender'] = cleaned_train['Gender'].astype(str)
cleaned_train['Home_Owner'] = cleaned_train['Home_Owner'].astype(str)

# Changing the datatype of Objects to float, str and int accordingly in test file
cleaned_test['Loan_Amount_Requested'] = cleaned_test['Loan_Amount_Requested'].astype(int)
cleaned_test['Length_Employed'] = cleaned_test['Length_Employed'].astype(float)
cleaned_test['Income_Verified'] = cleaned_test['Income_Verified'].astype(str)
cleaned_test['Purpose_Of_Loan'] = cleaned_test['Purpose_Of_Loan'].astype(str)
cleaned_test['Gender'] = cleaned_test['Gender'].astype(str)
cleaned_test['Home_Owner'] = cleaned_test['Home_Owner'].astype(str)


# In[26]:


#Checking the cleaned train file
cleaned_train.head()


# In[27]:


# Filling NA values of Length_Employed column with mean in train file
cleaned_train['Length_Employed'] = cleaned_train['Length_Employed'].fillna(value=cleaned_train["Length_Employed"].mean())

# Filling NA values of Length_Employed column with mean in test file
cleaned_test['Length_Employed'] = cleaned_test['Length_Employed'].fillna(value=cleaned_test["Length_Employed"].mean())


# In[28]:


# instatiate sklearn's labelencoder
from sklearn import preprocessing
le = preprocessing.LabelEncoder()

# Encoding the categorical values in train file
cleaned_train['Income_Verified'] = le.fit_transform(cleaned_train['Income_Verified'])
cleaned_train['Purpose_Of_Loan'] = le.fit_transform(cleaned_train['Purpose_Of_Loan'])
cleaned_train['Gender'] = le.fit_transform(cleaned_train['Gender'])
cleaned_train['Home_Owner'] = le.fit_transform(cleaned_train['Home_Owner'])


# Encoding the categorical values in train file
cleaned_test['Income_Verified'] = le.fit_transform(cleaned_test['Income_Verified'])
cleaned_test['Purpose_Of_Loan'] = le.fit_transform(cleaned_test['Purpose_Of_Loan'])
cleaned_test['Gender'] = le.fit_transform(cleaned_test['Gender'])
cleaned_test['Home_Owner'] = le.fit_transform(cleaned_test['Home_Owner'])

cleaned_train.head()


# In[29]:


# Finding null values in our cleaned train file
null_counts = cleaned_train.isnull().sum()
print("Number of null values in each column:\n{}".format(null_counts))

# Finding null values in our cleaned test file
null_counts = cleaned_test.isnull().sum()
print("Number of null values in each column:\n{}".format(null_counts))


# In[30]:


cleaned_train['Loan_Amount_Requested']


# In[31]:


# Assigning our cleaned train file to a new variable
cleaned_train_data = cleaned_train

# Checking the datatypes of all our columns.
cleaned_train_data.info()


# In[32]:


# Assigning our cleaned test file to a new variable
cleaned_test_data = cleaned_test

cleaned_test_data


# Modelling
# Lets, first extract the target variable that is "Interest rate" from the table and our predictors from the train data

# In[33]:


# Extracting the target variable
y = cleaned_train_data['Interest_Rate']


# Removing the interest column
x = cleaned_train_data.drop(['Interest_Rate'], axis = 1)


# We will split our data into 80% for our training and remaining 20% for testing.

# In[34]:


import sklearn.model_selection as cv
x_train, x_test, y_train, y_test = cv.train_test_split(x, y, test_size=.20)


# Decision Tree

# In[37]:


from sklearn import tree
dt = tree.DecisionTreeClassifier(max_depth=11)
dt.fit(x_train, y_train)
dt.score(x_test, y_test)


# Random Forest

# In[38]:


from sklearn import ensemble
rf = ensemble.RandomForestClassifier(max_depth=11)
rf.fit(x_train, y_train)
rf.score(x_test, y_test)


# In[39]:


y_pred = rf.predict(x_test)

from sklearn.metrics import confusion_matrix
confusion_matrix(y_test, y_pred)


# Apply to data test

# In[40]:


# Using the Random Forest to predict our cleaned test data
import numpy as np
y_pred = rf.predict(cleaned_test_data)
Interest_Rate = np.array(y_pred)
cleaned_test_data['Interest_Rate'] = y_pred.tolist()


# In[41]:


cleaned_test_data.head()


# In[42]:


cleaned_train_data.to_csv("Final_Train_Data.csv")
cleaned_test_data.to_csv("Final_Test_Data.csv")

