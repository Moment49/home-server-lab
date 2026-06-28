# Contributing to Home Server Lab

Thanks for checking out this project. This repo documents the process of building a personal home server from scratch using an old HP EliteBook — covering Ubuntu Server setup, network security, Docker services, Django deployment and a cybersecurity home lab.

Contributions are welcome, especially if you have hit similar problems and found better fixes, or if you are following along and something in the docs is unclear or out of date.

---

## What You Can Contribute

- Fix typos or unclear wording in any documentation
- Improve or correct a setup step that did not work for your hardware or OS version
- Add notes for a different laptop brand or Linux distro
- Suggest better security practices or tools
- Share a problem you hit that is not documented yet and how you fixed it
- Improve scripts in the `/scripts` folder

---

## What This Repo Is Not

This is a personal learning project and home lab documentation, not a production open source tool. Please do not open pull requests that:

- Change the overall architecture or direction of the project
- Add entirely new services not related to the documented stack
- Include real credentials, IPs, passwords or personal config values

---

## How to Contribute

1. Fork the repository
2. Create a new branch with a descriptive name
```bash
git checkout -b fix/nginx-config-typo
git checkout -b docs/add-docker-compose-notes
```
3. Make your changes
4. Commit with a clear message
```bash
git commit -m "docs: fix incorrect netplan indentation example"
git commit -m "fix: correct UFW command in security setup guide"
```
5. Push to your fork and open a Pull Request against the `main` branch
6. Describe what you changed and why in the PR description

---

## Writing Style

To keep the docs consistent:

- Write in plain clear English — this repo is meant to be accessible to beginners
- Document the *why* not just the *what* — explain why a step matters
- If you hit a problem and fixed it, add it to the **Problems I Hit** section of the relevant doc
- Use placeholder values for anything sensitive — never real IPs, passwords or credentials

```
✅ Use:  192.168.1.100, youruser, yourdomain.com, YOUR_API_KEY
❌ Never: real IPs, real usernames, real passwords, real tokens
```

---

## Opening an Issue

If you found something broken or confusing but do not want to submit a PR, open an issue and describe:

- Which doc or step the problem is in
- What you expected to happen
- What actually happened
- Your OS and hardware if relevant

---

## Questions

If you are following along and have questions about the setup, feel free to open an issue with the `question` label. This repo is as much about learning together as it is about documentation.
