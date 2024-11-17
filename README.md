# CRACKED-PHP

A minimal, statically-linked HTTP server docker container image based on FrankenPHP and DaemonTools, designed to serve PHP applications in a KISS manner.

### Features
- **Ultra-minimal footprint**: Built from scratch container with only essential static binaries
- **Secure by design**: Minimal attack surface with no unnecessary components
- **PHP-ready**: Includes FrankenPHP for PHP application serving
- **Process supervision**: Uses DaemonTools for reliable process management
- **Easy to extend**: Add your own app, dependencies, configuration, and run scripts
- **Multi-architecture support**: Builds for both ARM64 and AMD64 platforms

### Components
- **FrankenPHP**: Modern PHP runtime and web server
- **DaemonTools**: Process supervision and management
- **BusyBox**: Helpful Unix utilities

*All binaries are statically linked*

## How to use the image for an application
Look at the `example-app` directory for an example.

### Process Supervision
[DJ Bernstein's DaemonTools](https://cr.yp.to/daemontools.html) is used for process launching and supervision. Here's how it works:

1. The `/launcher` directory contains service directories that DaemonTools monitors
2. Each service directory must contain a `run` script that starts your service
3. DaemonTools' `svscan` watches these directories and ensures services stay running
4. `supervise` monitors each service and automatically launches it and restarts it if it crashes

For example, to launch your app:
```
launcher/
└── your-app/
    └── run           # Script that starts your-app
```

The `run` script should be executable and might look like:
```bash
#!/bin/busybox sh
exec /bin/frankenphp run /app
```

### Application Structure
Your application should follow this structure:
```
your-app/
├── makefile             # Optional makefile for local development
├── your-app/            
│   ├── Caddyfile        # Web server configuration
│   ├── php.ini          # PHP configuration
│   └── public_html/     # Your PHP application files
└── launcher/            # DaemonTools service directories
    └── your-app/        # Service directory for FrankenPHP
        └── run          # Executable script to start FrankenPHP
```

Try the example-app:
```bash
cd example-app
make build
make run
```

Two volumes are mounted by default in the example-app makefile:
- `/launcher`: For DaemonTools service directories containing your service run scripts
- `/app`: For your PHP application files