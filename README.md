# Зависимости

## 1. silver sercher (ag) 

## 2. bash-language-server

```bash
npm install -g bash-language-server
```

## 3. pyright

## 4. nerd font

##  5. ctags

```bash
sudo apt-get install exuberant-ctags
```

## 6. lua language server:

1. **Install dependencies:**

```bash
sudo apt update
sudo apt install -y git build-essential ninja-build luarocks
```

2. **Clone the repository:**

```bash
git clone https://github.com/LuaLS/lua-language-server.git
cd lua-language-server
git submodule update --init --recursive
```

3. **Build the server:**

```bash
cd 3rd/luamake
./compile/install.sh
cd ../..
./3rd/luamake/luamake rebuild
```

4. **Add to your PATH:**

```bash
echo 'export PATH=$PATH:/home/leev/lua-language-server/bin/' >> ~/.bashrc
source ~/.bashrc
```

5. **Verify installation:**

```bash
lua-language-server --version
```

You should see the version output.[^3]
