# Set environment variables
# export PNPM_HOME="/pnpm"
# export PATH="$PNPM_HOME:$PATH"

# Enable corepack
# corepack enable

# Create and navigate to the working directory
mkdir -p /app
# cd /app

# Copy package.json and pnpm-lock.yaml (assuming they are in the current directory)
cp package.json pnpm-lock.yaml app/

echo "Base environment setup complete."