FROM alpine:3.6
RUN adduser -S -s /bin/bash user

LABEL version v1.5.0.alpha.16-4-g70442aa-mine

ENV ADOC_VERSION "1.5.6.1"
ENV ADOC_PDF_VERSION "1.5.0.alpha.16"

RUN apk add --no-cache --update bash findutils ruby ruby-io-console ruby-bundler && \
        gem install --no-ri --no-rdoc asciidoctor --version $ADOC_VERSION && \
        gem install --no-ri --no-rdoc asciidoctor-diagram && \
        gem install --no-ri --no-rdoc asciidoctor-pdf --version $ADOC_PDF_VERSION && \
        gem install --no-ri --no-rdoc rouge && \
        gem uninstall asciidoctor-pdf

RUN mkdir -p /usr/local/asciidoctor-pdf /usr/local/lib/asciidoctor/extensions /usr/local/lib/asciidoctor-pdf/extensions
ADD files/asciidoctor-pdf.v1.5.0.alpha.16-4-g70442aa-mine.tar.gz /usr/local/asciidoctor-pdf

COPY scripts/asciidoctor-pdf /usr/local/bin/
COPY scripts/asciidoctor /usr/local/bin/
COPY scripts/make-asciidoc /usr/local/bin/
COPY extensions/hyphenation.rb /usr/local/lib/asciidoctor/extensions

RUN mkdir /documents && chown user /documents

VOLUME /config/asciidoctor
VOLUME /config/asciidoctor-pdf

WORKDIR /documents
VOLUME /documents

USER user
CMD "/bin/bash"
