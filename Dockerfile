FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev libjpeg-dev libpng-dev
RUN git clone https://github.com/kermitt2/pdfalto.git
WORKDIR /pdfalto
RUN git clone https://github.com/kermitt2/xpdf-4.03.git
RUN cmake -DCMAKE_C_COMPILER=afl-clang -DCMAKE_CXX_COMPILER=afl-clang++ .
RUN make
RUN make install
RUN mkdir /pdfaltoCorpus
RUN wget https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf
RUN wget http://www.africau.edu/images/default/sample.pdf
RUN wget https://file-examples.com/wp-content/uploads/2017/10/file-sample_150kB.pdf
RUN wget https://file-examples.com/wp-content/uploads/2017/10/file-example_PDF_500_kB.pdf
RUN mv *.pdf /pdfaltoCorpus
ENV LD_LIBRARY_PATH=/usr/local/lib/

ENTRYPOINT  ["afl-fuzz", "-i", "/pdfaltoCorpus", "-o", "/pdfaltoOut"]
CMD ["/pdfalto/pdfalto", "@@"]
