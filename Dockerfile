FROM ivydl/ivy:latest

# Install Ivy
RUN rm -rf ivy && \
    git clone https://github.com/ivy-dl/ivy && \
    cd ivy && \
    cat requirements.txt | grep -v "ivy-" | pip3 install --no-cache-dir -r /dev/stdin && \
    cat optional.txt | grep -v "ivy-" | pip3 install --no-cache-dir -r /dev/stdin && \
    python3 setup.py develop --no-deps

# Install Ivy Models
RUN git clone https://github.com/ivy-dl/models && \
    cd models && \
    cat requirements.txt | grep -v "ivy-" | pip3 install --no-cache-dir -r /dev/stdin && \
    python3 setup.py develop --no-deps

COPY requirements.txt /
RUN cat requirements.txt | grep -v "ivy-" | pip3 install --no-cache-dir -r /dev/stdin

RUN python3 test_dependencies.py -fp requirements.txt && \
    rm -rf requirements.txt

RUN mkdir ivy_models
WORKDIR /ivy_models