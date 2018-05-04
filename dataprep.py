import numpy as np
import re

TOKENS = ["body", "header", "row", "single", "double", "quadruple", "btn-active", "btn-inactive", "btn-green", "btn-orange", "btn-red", "big-title", "small-title", "text", "{", "}"]
NUM_TOKENS = len(TOKENS)

def to_categorical(i, length):
    one_hot_encoding = np.zeros(length)
    one_hot_encoding[i] = 1
    return one_hot_encoding

def to_token(encoding):
    idx, = np.where(encoding == 1)
    print(idx[0])
    return TOKENS[idx[0]]

def to_token_text(token_text_hot):
    token_text = [
        to_token(encoding)
        for encoding in token_text_hot
    ]
    return token_text_array



with open('./all_data/0B660875-60B4-4E65-9793-3C7EB6C8AFD0.gui') as token_file:
    token_text = token_file.read().rstrip()
    # for each word
    token_text_array = re.split(r',\s*|\s+', token_text)

    token_text_hot = [
        to_categorical(TOKENS.index(token), NUM_TOKENS)
        for token in token_text_array
    ]
    print(token_text_hot)


# read in dsl file
# split w regex
# turn token into one hot encoding
# make windows...
