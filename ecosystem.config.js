// ecosystem.config.js
module.exports = {
  apps: [
    {
      name: 'nextjs-app',
      script: 'node_modules/next/dist/bin/next',
      args: 'start -p 3000', // Puerto interno 3000
      exec_mode: 'fork',
      instances: 1,
      autorestart: true,
      listen_timeout: 10000,
      kill_timeout: 10000,
    },
  ],
};