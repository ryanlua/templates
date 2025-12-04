# Roblox Dev Container Template

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/ryanlua/templates?quickstart=1)

Dev Container Template for Roblox. Allows Roblox developers to develop in the cloud easily and with zero effort. Supporting your favorite tools with automatic installation so all you need to focus on is scripting.

### Why should I use dev containers?

Dev containers allow anyone to code, no matter what device, experience level, or location.

* Runs on any device in the browser (even phones)
* No need to manually install tools or packages
* Very fast setup and time to start developing

This makes it great for teams, open-source projects, or even just you if you travel a lot or switch devices. Some examples of how dev containers could be used include:

* Onboarding new scripters and collaborating together using [Live Share](https://marketplace.visualstudio.com/items?itemName=MS-vsliveshare.vsliveshare) without needing to spend time installing the proper tools
* Allowing people to easily contribute to your project and test their changes on their machine
* Making fast changes to your code when your main development machine is not available or you don't have access to a powerful machine.

### Known issues and remarks

Known issues related to using Rojo in a dev container.

#### A device running Roblox Studio is needed to sync

You need a device that can run Roblox Studio to be able to sync code and publish places. This just allows you to use any device to edit code and a bit more. You can still build models and places using Rojo as well as download them.

#### Rojo can't install the Roblox Studio plugin

Rojo can't install the Rojo plugin for Roblox Studio since it is running in the cloud and does not have access to your device. You will to install it manually from [GitHub](https://github.com/rojo-rbx/rojo/releases) or the [Roblox Creator Store](https://create.roblox.com/store/asset/13916111004).

#### Port needs to be 80 on Roblox Studio

Because of how GitHub Codespaces works, if you want to sync to Roblox Studio in a codespace, you need to set the port to `80` in the plugin even though it shows it is forwarded as `34872`.

You also need to remove the `https://` at the beginning and the `/` end of the forwarded address. `https://your-project-34872.app.github.dev/` turns into `your-project-34872.app.github.dev`.

## Examples

This template is used in the following repositories:

* [rojo-showcase-template](https://github.com/ryanlua/rojo-showcase-template)
* [Satchel](https://github.com/ryanlua/Satchel) (experimental support)

Go test out this template in the wild and see how it works.

## Applying this template

The easier way to use this template is to use [GitHub Codespaces](https://github.com/features/codespaces) to apply it to your project.

1. Open your repository and to go the branch you want to use the dev container on.

1. Click the **Code** button, then click the **Codespaces** tab, and then click **Create codespace**.

    <img alt="Create codespace on main" src="https://github.com/ryanlua/templates/assets/80087248/df4e2f4b-0ad3-4ae9-86a9-e43b4841df80" width=50%>

1. Wait for the codespace to be created and open the Command Palette with <kbd>Shift</kbd>+<kbd>Command</kbd>+<kbd>P</kbd> (Mac) / <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> (Windows/Linux), then start typing "Add Dev Container Configuration Files". Click **Add Dev Container Configuration Files...**.

    <img alt="Command Palette" src="https://github.com/ryanlua/templates/assets/80087248/3ee5982f-0f9a-4f36-98d9-f4a0d7fa0d4e" width=75%>

1. Select **Create a new configuration...**. Type `ghcr.io/ryanlua/templates/roblox` and click **Use 'ghcr.io/ryanlua/templates/roblox' as a template...**.

    <img alt="Add Dev Container Configuration Files" src="https://github.com/ryanlua/templates/assets/80087248/8aa955a8-4a9f-4a88-a476-6035cd01e7dd" width=75%>

1. A new file `devcontainer.json` will be created. This is your dev container configuration with the Roblox template applied. In the Activity Bar, click the **Source Control** view and stage the file by clicking + next to the file.

    <img alt="Source Control" src="https://github.com/ryanlua/templates/assets/80087248/1c3fa187-9e49-44a8-924c-1cda4df27010" width=50%>

1. To commit your staged changes, type a commit message describing, then click **Commit**, then **Sync**.

    <img alt="Commit" src="https://github.com/ryanlua/templates/assets/80087248/ff9a73ff-9b52-4a18-8328-7871e76c6a32" width=50%>

Now when someone opens your project in a [supporting tool](https://containers.dev/supporting) like GitHub Codespaces, it will use your dev container configuration to set up Rojo and [Rokit](https://github.com/rojo-rbx/rokit), [Aftman](https://github.com/LPGhatguy/aftman), or [Foreman](https://github.com/Roblox/foreman) (optionally). Tell your contributors you support codespaces and add a link to an "Open in GitHub Codespaces" badge by reading about "[Facilitating quick creation and resumption of codespaces](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/setting-up-your-repository/facilitating-quick-creation-and-resumption-of-codespaces)"

What's next is to modify your dev container configuration to do things like automatically install toolchain tools, install [Wally](https://wally.run/) dependencies, and more.

## Configuring the Dev Container

By default this template will install Rojo, Rokit, and a few VSCode extensions to get you started.

### Automatically installing tools, packages, and dependencies

> [!NOTE]
> Rokit has compatibility with projects that already use `aftman.toml` and `foreman.toml` files so the default toolchain manager should work with your project.

You can modify the `devcontainer.json` to be able to install toolchain tools and more by changing the `postCreateCommand` key.

Here, we will install all Rokit tools from your project's `rokit.toml` file. This is useful if you have a project that uses Rokit and you want to install all the tools automatically.

```json5
{
	...

	// Install Rokit tools
	"postCreateCommand": "rokit install --no-trust-check",

	...
}
```

If your project uses Wally, you use the `&&` operator to specify multiple commands. Here, we will install Rokit tools and Wally packages.

```json5
{
	...

	// Install Rokit tools and Wally packages
	"postCreateCommand": "rokit install --no-trust-check && wally install",

	...
}
```

You now can install everything that your project needs, automatically, without needing to do anything. They are other commands you can use as well like `apt` or `git`.

### Adding more VSCode extensions

The template installs a few VSCode extensions to get you started which include:

* [Rojo](https://marketplace.visualstudio.com/items?itemName=evaera.vscode-rojo) (required)
* [Selene](https://marketplace.visualstudio.com/items?itemName=Kampfkarren.selene-vscode)
* [StyLua](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.StyLua)
* [Luau Language Server](https://marketplace.visualstudio.com/items?itemName=johnnymorganz.luau-lsp)

You can remove all the extensions except for Rojo if you want to start fresh. You can also add more extensions by modifying the `devcontainer.json` file.

The extensions come pre-filled like the below. You can add more extensions or remove some.

```json5
{
	...

	"customizations": {
		"vscode": {
			"extensions": [
				"kampfkarren.selene-vscode",
				"johnnymorganz.stylua",
				"johnnymorganz.luau-lsp"
			]
		}
	},

	...
}
```

### Additional configuration

This covers the most important parts of configuring your dev container but you can learn more at the [Dev Container metadata reference](https://containers.dev/implementors/json_reference/) where you can learn more about how to configure your dev container which includes

* Using a different forwarded port
* Changing/overriding environment variables
* Mounting to your container which allows caching
