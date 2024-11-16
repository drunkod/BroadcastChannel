# Run the base shell script
source ./shells/base.sh

# Install dependencies
pnpm install --frozen-lockfile --prefix app/

# Copy the project files (assuming they are in the current directory)
cp -r ./* app/

# Run the build command
export $(cat .env.example)

cd app
# export DOCKER=true
pnpm run build

echo "Build completed."