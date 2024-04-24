# Trame Tram Trame

This is the code repository for the [Mistral]() re-training files for the project [Trame Tram Trame](https://github.com/Mastis3000/head-md-drawing-futures).

## Retraining Workflow
Here is the current workflow for training a large language model with your own data.

## Retraining
We are using Google Colab servers for the retraining. The training tools are mostly based around Huggingface [Autotrain](https://huggingface.co/autotrain).

Here is the direct Jupyter source code we are running for this retraining:
http://...

## Data
Start by downloading the table of values as `data.tsv` from Google Spreadsheet.

## Convert
Convert the `.tsv` file to `.csv` for training, indentifying the rows and collumns you want :

```
% 
```

## Inferencing
We are using [Ollama](https://ollama.com) on a 16GB M2 Mac Mini Pro.

## Repository
The retrained models are stored on [Huggingface](https://huggingface.co/headmediadesign).

## Tutorial
Cf. [Tutorial: How to convert HuggingFace model to GGUF format](https://github.com/ggerganov/llama.cpp/discussions/2948)

## Dernier entraînement
Actuellement : <https://huggingface.co/headmediadesign/irad-tempete-mistral-2024-04-15>

### Install Tools
These will be needed for Huggingface downloading as well as for conversion to the [GGUF](https://medium.com/@phillipgimmi/what-is-gguf-and-ggml-e364834d241c format).

```
% pip install huggingface_hub
% python download.py
% git clone https://github.com/ggerganov/llama.cpp.git
% pip install -r llama.cpp/requirements.txt
% python llama.cpp/convert.py -h
```

If the above worked, the Llama `convert` help parameters should have printed out.

### Download retrained model
First, change repository name in `./models/download.py` to match latest training. For the user token, cf. <https://huggingface.co/settings/tokens>. Then run the download script.

```
% cd models
% python download.py
```

### Convert to GGUF
In this example, we are still inside the `models` folder. The downloaded folder is named `irad-tempete-mistral-2024-04-15`. Change accordingly.

```
% python llama.cpp/convert.py irad-tempete-mistral-2024-04-21 --outfile irad-tempete-mistral-2024-04-21.gguf --outtype q8_0
```

To keep quality of original model, use `--outtype f16` or `--outtype f32`.

*Note: I tried `f32` and it was way slower than `q8_0` on my Mac M1 Max. Moving back to `q8_0`.

## Verify the GGUF model was created:

ls -lash irad-tempete-mistral-2024-04-21.gguf

### Remove Model Folder
Once the `GGUF` file has been created, we should be able to remove to the big model folder:

```
rm -r irad-tempete-mistral-2024-04-21/
```

This still needs to be double-checked, but a first test seems to confirm it.

### Create Ollama Model
Turn on [Ollama]() on your machine.

Create a text file named `Modelfile` (no extension). Inside this file add:

```
From ./irad-tempete-mistral-2024-04-21.gguf
```

% ollama create irad-tempete-mistral-2024-04-21.gguf -f Modelfile

Ollama does its thing:
```
transferring model data 
creating model layer 
using already created layer sha256:6e6ca7903127da07c7311722def9e325f38392b019e8881fc33d5a78198bc38c 
writing layer sha256:2f0ea54b05dac2c76f592303859d12d7ac13a8a44d0c80be59a63930ccef2033 
writing manifest 
success
```

### Run Model

From anywhere you can now run the ollama model.

```
% ollama list
```

```
% ollama run irad-tempete-mistral-2024-04-21.gguf
```

*Idiot alert: I forgot the `.gguf` in that Ollama script and lost a full day's work trying to figure out why >:={

### Remove Model from Ollama

```
% ollama list
NAME                                            ID              SIZE    MODIFIED     
irad-tempete-mistral-2024-04-15.gguf:latest     8cdf441bcae0    7.7 GB  2 hours ago 
llama2:latest                                   fe938a131f40    3.8 GB  4 months ago

% ollama rm irad-tempete-mistral-2024-04-15.gguf
```
