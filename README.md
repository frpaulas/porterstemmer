# Stemmer

Word stemmer based upon Porter 2 stemmer algorithm, written in Elixir 1.0.

http://http://tartarus.org/martin/PorterStemmer/

## License

This is licensed under [the MIT license](LICENSE.md).

## Exceptions

Does not stem words beginning with an uppercase letter. 
This is to prevent stemming of acronyms or names.

## Usage

PorterStemmer.stem(<someword>)
