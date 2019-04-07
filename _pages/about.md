---
permalink: /about/
title: 'Kieran Marron'
script: |
    $(function() {
        if(window.location.hash === '#sent') {
            $('#sent').show();
        }
    });
---

I'm a Bristol based developer with 10+ years experience working in C# and .Net
technologies.

I currently work as a Lead Developer for [Sitecore][1], focusing on delivering
new features and improvements to the core products using dotnet core and future
tooling.

## Contact

<div id="sent" style="display:none">
    <blockquote>
        <p>Thanks for the message, I'll be in contact soon!</p>
    </blockquote>
</div>

<form action="https://formspree.io/contact@kieranties.com" method="POST">
    <input type="hidden" name="_next" value="#sent" />

    <input type="text" name="name" placeholder="Name" required />
    <input type="email" name="_replyto" placeholder="Email" required />
    <textarea name="message" placeholder="Message" rows="5" required ></textarea>

    <input type="submit" value="Send" />
</form>

[1]:https://www.sitecore.com/