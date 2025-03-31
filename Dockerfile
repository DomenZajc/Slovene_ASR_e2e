FROM --platform=linux/amd64 nvcr.io/nvidia/nemo:22.07 as nemo

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install ffmpeg -y

FROM nemo as service

ARG DEBIAN_FRONTEND=noninteractive

# Fix dependency issues
RUN pip install --upgrade pip && \
    pip install pydantic==1.10.8 && \
    pip install inflect==5.6.0

COPY . /opt/asr
RUN python3 -m pip install -r /opt/asr/requirements.txt
WORKDIR /opt/asr

ENTRYPOINT [ "python3", "server.py" ]
