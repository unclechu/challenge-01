# deploy

1. Clone this repo and go to directory:

  ```bash
  $ git clone https://github.com/unclechu/challenge-01
  $ cd challenge-01
  ```
2. Sync submodules:

  ```bash
  $ git submodule update --init
  ```

3. Install dependencies (it will deploy front-end and other stuff too):

  ```bash
  $ npm install
  ```

4. Copy [config.json.example](./config.json.example) to `config.json` and do changes in `config.json` if you need it;

5. Run start script:

  ```bash
  $ ./start.sh
  ```
