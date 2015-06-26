# Summoner's Rift Map Stitcher
A tool for stitching together an extra-large map of Summoner's Rift (League of Legends)

## Run
    pip install -r requirements.txt
    hy fetch.hy
	hy stitch.hy
	
## Known Issues

Right now the fetcher hangs after downloading all the images. You can CTRL+C at this point and the stitcher will still work.