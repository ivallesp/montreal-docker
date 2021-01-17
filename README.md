# Montreal-Forced-Aligner in a Docker

I have been struggling to make MFA work on my local machine, so I bundled everything into a Docker container so that you don't have to go through the installation process anymore. I have used version 1.1.0.beta-2 of MFA, and the Kaldi official docker image as base.

I have tested the `mfa_align` and the `mfa_generate_dictionary` commands and they are working like a charm.

## How does it work?

The docker container has been configured to have an entrypoint that accepts commands as input at run time. The following are a couple of examples of commands to show how it works. For that, I included a corpus demo extracted from the [MLS dataset](https://arxiv.org/abs/2012.03411).

Note: macOS users may need to run `brew install coreutils` to install the `realpath` , `dirname` and `basename` commands.

### Alignment

The following command runs the montreal aligner pretrained model and outputs the alignment between the audio clips and the text. It must create one or more `textgrid` files in the output directory.

``` 
# Path to the montreal corpus, formatted following the montreal standards.
CORPUS_PATH=test/corpus

# The lexicon file path, must be generated with the mfa_generate_dictionary function.
LEXICON_PATH=test/lexicon.txt

# The language of the utterances to align. See supported languages.
LANGUAGE=spanish

# Path where the output textgrid files will be stored
OUTPUT_PATH=test/alignments

docker run -v $(realpath $CORPUS_PATH):/app/corpus \
           -v $(realpath $LEXICON_PATH):/app/lexicon.txt \
           -v $(realpath $OUTPUT_PATH):/app/out \
           ivallesp/mfa \
           ./bin/mfa_align \
                /app/corpus \
                /app/lexicon.txt \
                $LANGUAGE \
                /app/out
```

### Generate dictionary (lexicon)

The following command takes a corpus as input and generates a lexicon file, containing the pronunciations of all the words in the corpus, using a pretrained G2P model. It must create the lexicon file provided as input parameter.

``` 
# Path to the g2p model. The models are bundled into the container and can be located in the /app/montreal-forced-aligner/pretrained_models
G2P_PATH=pretrained_models/spanish_g2p.zip

# Path to the montreal corpus, formatted following the montreal standards.
CORPUS_PATH=test/corpus

# The lexicon file path to be generated.
LEXICON_OUTPUT_PATH=test/lexicon.txt

docker run -v $(realpath $CORPUS_PATH):/app/corpus \
           -v $(dirname $(realpath $LEXICON_OUTPUT_PATH)):/app/out \
           ivallesp/mfa \
           ./bin/mfa_generate_dictionary \
                    $G2P_PATH \
                    /app/corpus \
                    /app/out/$(basename $LEXICON_OUTPUT_PATH)
```

## Contribution

Contributions to this repository are welcome, feel free to issue a pull request. If you find an issue, please let me know and I will correct it as soon as possible.

## License

This repository is licensed under GNU General Public License v3.0. Check the [LICENSE](./LICENSE) file for more info.
