FROM kaldiasr/kaldi:2020-09

# Install curl
RUN apt update && apt install -y curl

# Download Montreal Forced Aligner and setup the directory
RUN mkdir /app
WORKDIR /app
ARG MFA_URL="https://github.com/MontrealCorpusTools/Montreal-Forced-Aligner/releases/download/v1.1.0-beta.2/montreal-forced-aligner_linux.tar.gz"
ARG MFA_FILENAME="montreal-forced-aligner_linux.tar.gz"
RUN wget $MFA_URL              \
    && tar -zxvf $MFA_FILENAME \
    && rm $MFA_FILENAME

WORKDIR /app/montreal-forced-aligner

ARG MONTREAL_COMMIT=94a07b73fabbff21e45b5f40c7c12bfed59dd120

# Download G2P models
ARG G2P_BASE_URL=https://raw.githubusercontent.com/MontrealCorpusTools/mfa-models/$MONTREAL_COMMIT/g2p
RUN for FN in $(curl $G2P_BASE_URL/index.txt); do echo $G2P_BASE_URL/$FN.zip && wget $G2P_BASE_URL/$FN.zip; done

# Download Accoustic models
ARG ACC_BASE_URL=https://raw.githubusercontent.com/MontrealCorpusTools/mfa-models/$MONTREAL_COMMIT/acoustic
RUN for FN in $(curl $ACC_BASE_URL/index.txt); do echo $ACC_BASE_URL/$FN.zip && wget $ACC_BASE_URL/$FN.zip; done

# Move all the models to the pretrained_models folder
RUN mv *.zip pretrained_models

# Download the proveded lexicons
ARG DIC_BASE_URL=https://raw.githubusercontent.com/MontrealCorpusTools/mfa-models/$MONTREAL_COMMIT/dictionary
RUN for FN in $(curl $DIC_BASE_URL/index.txt); do echo $DIC_BASE_URL/$FN.dict && wget $DIC_BASE_URL/$FN.dict; done
RUN mkdir dictionaries && mv *.dict dictionaries


# Generate dummy script for easy interaction from entrypoint
RUN echo 'echo "$($@)"' > runner.sh

ENTRYPOINT ["/bin/bash", "runner.sh"]


