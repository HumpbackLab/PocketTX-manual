# PocketTX-manual

Power your RC flights with your phone. A smart adapter converting Android devices to ExpressLRS protocol.

This repository contains the source code for the PocketTX user manual, written in [Typst](https://typst.app/).

## Project Structure

- `user-guide.typ`: The main Typst source file for the manual.
- `assert/`: Directory containing images and assets used in the manual.
- `.gitignore`: Git ignore file to exclude build artifacts like PDF files.

## How to Compile

To compile the manual to PDF, you need to have Typst installed. Run the following command:

```bash
typst compile user-guide.typ
```
